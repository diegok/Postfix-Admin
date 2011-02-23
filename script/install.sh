#!/usr/bin/sh

cpanm Catalyst::Runtime Catalyst::Plugin::ConfigLoader Catalyst::Plugin::Static::Simple Catalyst::Action::RenderView Catalyst::Plugin::Session Catalyst::Plugin::Session::Store::FastMmap Catalyst::Plugin::Session::State::Cookie parent Config::General DBIx::Class DBIx::Class::TimeStamp Crypt::PasswdMD5 HTML::FormHandler HTML::FormHandler::Model::DBIC Email::Valid Catalyst::Plugin::Unicode::Encoding
