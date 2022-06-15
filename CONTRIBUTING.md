Thank you for considering contributing to ls-auth-ui. Whether you are using the project, reporting bugs, requesting features, or submitting code your involvement helps build ls-auth-ui.


# Support questions

If you have questions about ls-auth-ui the best point of contact is sean@learnershape.com.


# Getting involved

We welcome bug reports, feature requests, and code contributions.


# Reporting issues

Please report bugs on our issues page. The more information you can provide the faster a fix can be created. The following information helps:

- Describe what you expected to happen
- A simple test case that triggers the bug. This is also known as a minimal reproducible example.
- Describe what actually happened. If you can include tracebacks or logs these are very useful.
- List the code commit you are using together with the versions of any relevant software.


## Security issues

If you think a bug may have security implications please report it privately to sean@learnershape.com. Your report will be acknowledged and a plan established to address the issue. By having a fix available before a security issue is announced the public impact is hopefully reduced.

At Learnershape we are running lsgraph on a private subnet preventing direct access. This provides additional security benefits, but we are also committed to keeping lsgraph as secure as possible when running in a less secure environment.


# Contributing

## Guidelines

ls-auth-ui is a young project under active development. There is a lot to do and we would love to receive contributions from you.

If you want to contribute but do not know what to work on take a look at the open issues or contact sean@learnershape.com.

If you already have a new feature in mind the best place to start is creating a new feature request on our issues page. This avoids duplicated effort and ensures we will be able to merge your contribution into ls-auth-ui when completed.

## license

This project is licensed under the GNU LGPL v3 license and by contributing you would be releasing your code under this license. The full text of this license can be found in the COPYING and COPYING.LESSER files.

When creating a new source file it must begin with a license header:



    Copyright (C)2022  Learnershape and contributors

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.


## setting up development environment

ls-auth-ui is a rails-based web application. A docker-compose file is available for rapidly starting an instance together with a supporting database instance.

## running tests

The test suite can be run with 

`docker-compose run --rm web rspec`

# Code of conduct

We hope to build a welcoming and friendly community around this project. Everyone is invited to participate. Unethical and unprofessional behaviour will not be tolerated. We have adopted the [Contributor Covenant](https://github.com/LearnerShape/ls-auth-ui/blob/main/CODE_OF_CONDUCT.md) to support this aim. Any issues can be reported to sean@learnershape.com or maury@learnershape.com.




