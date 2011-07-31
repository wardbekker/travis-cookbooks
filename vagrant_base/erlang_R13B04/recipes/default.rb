# Cookbook Name:: erlang R13B04
# Recipe:: default
# Author:: Ward Bekker <ward@tty.nl>
#
# Copyright 2008-2009, Joe Williams
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

execute "download Erlang/OTP R13B04" do
  not_if "test -f /tmp/otp_src_R13B04.tar.gz"
  command "wget http://www.erlang.org/download/otp_src_R13B04.tar.gz -O /tmp/otp_src_R13B04.tar.gz"
end

execute "unpack Erlang/OTP R13B04" do
  not_if "test -d /tmp/otp_src_R13B04"
  command "tar xzf /tmp/otp_src_R13B04.tar.gz -C /tmp"
end

unless `uname`.strip == 'Darwin'
  package "build-essential"
  package "libncurses5-dev openssl libssl-dev libsctp-dev libexpat1-dev"
end

script "build Erlang/OTP R13B04" do
  interpreter "bash"
  code <<-SH
  cd /tmp/otp_src_R13B04
  ./configure --prefix=/usr/local/erlang/R13B04 --enable-threads --enable-smp-support --enable-kernel-poll --enable-hipe --enable-sctp \
              #{"--with-ssl=/usr/lib/ssl/" unless `uname`.strip == 'Darwin'}
  make
  make install
  SH
end
