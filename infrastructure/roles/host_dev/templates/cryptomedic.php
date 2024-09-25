<?php

// Installed by ansible

global $myconfig;

$myconfig['security']['admin'] = '{{jehon_remote_cryptomedic_security_admin}}';

$myconfig['database'] = [
    'host'     => 'cryptomekpmain.mysql.db',
    'schema'   => 'cryptomekpmain',
    'username' => '{{jehon_remote_cryptomedic_database_username}}',
    'password' => '{{jehon_remote_cryptomedic_database_password}}',
    'rootpwd'  => ''
  ];

$myconfig['security']['key']  = '{{jehon_remote_cryptomedic_security_key}}';
$myconfig['security']['token'] = '{{jehon_remote_cryptomedic_security_token}}';
$myconfig['randomString'] = '{{jehon_remote_cryptomedic_security_random}}';

$myconfig['debug'] = true;
