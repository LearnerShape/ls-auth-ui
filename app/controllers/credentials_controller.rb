class CredentialsController < ApplicationController

  def update_transaction_ids_by_creator(creator:)
    credential_ids = Authentication.where(authenticator: creator).pluck(:credential_id)
    credentials = Credential.where(id: credential_ids).is_authenticated.uniq
    holder_api_ids = credentials.map(&:holder).uniq.map(&:api_id).compact
    holder_api_ids.each do |holder_api_id|
      update_transaction_ids_by_holder(holder_api_id: holder_api_id)
    end
  end

  def update_transaction_ids_by_holder(holder_api_id:)
    raw = Queries::GetCredentials.do(holder_id: holder_api_id)
    # holder only used for logger statement; can remove query when debugged
    holder = Contact.where(api_id: holder_api_id).first
    Rails.logger.info("update_transaction_ids_by_holder, holder_api_id=#{holder_api_id}, holder=#{holder.inspect}")
    Rails.logger.info("GetCredentials: response from api: #{raw}")
    rows = raw['credentials'] || []
    return if rows.empty?

    update_authentications_with_transaction_ids(transaction_id_rows: rows)
  end

  def update_authentications_with_transaction_ids(transaction_id_rows:)
    transaction_id_rows.each do |row|

      submission = row['submission_transaction_id']
      revocation = row['revocation_transaction_id']
      next if submission.blank? && revocation.blank?

      authentication = Authentication.where(api_id: row['id']).first
      next unless authentication.present?

      attrs = {}
      if submission.present? && authentication.submission_transaction_id != submission
        attrs.store(:submission_transaction_id, submission)
      end
      if revocation.present? && authentication.revocation_transaction_id != revocation
        attrs.store(:revocation_transaction_id, revocation)
      end
      next if attrs.blank?

      authentication.update(attrs)
    end
  end
end
