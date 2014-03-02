<?php
// For help join our mailing list. http://ocax.net/cgi-bin/mailman/listinfo/lista

$config = array(
	// See the list of directory names in app/themes for possible options
	'theme'=>'khaki',
	
	// your database connection
	'components'=>array(
		'db'=>array(
			'connectionString' => 'mysql:host=localhost;dbname=<%= @ocax_db_name %>',
			'emulatePrepare' => true,
			'username' => '<%= @ocax_db_username %>',
			'password' => '<%= @ocax_db_password %>',
			'charset' => 'utf8',
		),
	),
	// Do you want to be part of the ocax network? http://ocax.net/network/
	// We hope the network will provide support, automated backups and updates.
	'params'=>array(
		'ocaxnetwork'=>true,
	),

	// This default should be good. Only touch this if you've moved the base directories.
	'basePath'=>dirname(__FILE__).DIRECTORY_SEPARATOR.'..',	
);
return array_merge_recursive($config, require_once(dirname(__FILE__).'/_config.php'));
