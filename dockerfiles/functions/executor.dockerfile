#  Copyright 2018 U.C. Berkeley RISE Lab
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.

FROM fluentproject/base:latest

MAINTAINER Vikram Sreekanti <vsreekanti@gmail.com> version: 0.1

ARG repo_org=fluent-project
ARG source_branch=master
ARG build_branch=docker-build

USER root

# pipeline specific installs
RUN pip3 install numpy sklearn pyarrow pandas

# check out to the appropriate branch and install the Python KVS client
WORKDIR /fluent
RUN git remote remove origin && git remote add origin https://github.com/$repo_org/fluent
RUN git fetch -p origin && git checkout -b $build_branch origin/$source_branch
RUN cd kvs/client/python && python3.6 setup.py install --prefix=$HOME/.local
WORKDIR /

COPY start-funcs.sh /start-funcs.sh

# start the executor server
CMD bash start-funcs.sh
