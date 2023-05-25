<?php

// Installed by ansible

global $myconfig;

$myconfig['security']['admin'] = '{{jehon.credentials.cryptomedic.security_admin}}';

$myconfig['database'] = [
    'host'     => 'cryptomekpmain.mysql.db',
    'schema'   => 'cryptomekpmain',
    'username' => '{{jehon.credentials.cryptomedic.database_username}}',
    'password' => '{{jehon.credentials.cryptomedic.database_password}}',
    'rootpwd'  => ''
  ];

$myconfig['security']['key']  = '{{jehon.credentials.cryptomedic.security_key}}';
$myconfig['security']['token'] = '{{jehon.credentials.cryptomedic.security_token}}';
$myconfig['randomString'] = '{{jehon.credentials.cryptomedic.security_random}}';

$myconfig['debug'] = true;
