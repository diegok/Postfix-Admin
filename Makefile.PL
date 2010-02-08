#!/usr/bin/env perl

use inc::Module::Install;

name 'postadmin';
all_from 'lib/postadmin.pm';

requires 'Catalyst::Runtime' => '5.80018';
requires 'Catalyst::Plugin::ConfigLoader';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Action::RenderView';
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
