#!/usr/bin/env perl

use inc::Module::Install;

name 'postadmin';
all_from 'lib/postadmin.pm';

requires 'Catalyst::Runtime' => '5.80018';
requires 'Catalyst::Plugin::ConfigLoader';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Plugin::Unicode::Encoding';
requires 'Catalyst::Action::RenderView';
requires 'Catalyst::Plugin::Session';
requires 'Catalyst::Plugin::Session::Store::FastMmap';
requires 'Catalyst::Plugin::Session::State::Cookie';
requires 'Catalyst::Authentication::Store::DBIx::Class';

requires 'Catalyst::View::TT';

requires 'parent';
requires 'Config::General'; 

requires 'DBIx::Class';
requires 'DBIx::Class::TimeStamp';
requires 'Crypt::PasswdMD5';

requires 'HTML::FormHandler';
requires 'HTML::FormHandler::Model::DBIC';
requires 'Email::Valid';

catalyst;

install_script glob('script/*.pl');
auto_install;
WriteAll;
