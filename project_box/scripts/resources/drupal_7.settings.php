<?php

$databases = array();
$databases['default']['default'] = array(
  'driver' => 'mysql',
  'database' => 'VAGRANT',
  'username' => 'VAGRANT',
  'password' => 'VAGRANT',
  'host' => 'localhost',
  'prefix' => '',
);

$update_free_access = FALSE;
$drupal_hash_salt = '';
# $base_url = 'http://www.example.com';  // NO trailing slash!

/**
 * PHP settings:
 */
ini_set('session.gc_probability', 1);
ini_set('session.gc_divisor', 100);
ini_set('session.gc_maxlifetime', 200000);
ini_set('session.cookie_lifetime', 2000000);
# ini_set('pcre.backtrack_limit', 200000);
# ini_set('pcre.recursion_limit', 200000);

# $cookie_domain = '.example.com';
# $conf['site_name'] = 'My Drupal site';
# $conf['theme_default'] = 'garland';
# $conf['anonymous'] = 'Visitor';
# $conf['maintenance_theme'] = 'bartik';

/**
 * Fast 404 pages:
 */
$conf['404_fast_paths_exclude'] = '/\/(?:styles)\//';
$conf['404_fast_paths'] = '/\.(?:txt|png|gif|jpe?g|css|js|ico|swf|flv|cgi|bat|pl|dll|exe|asp)$/i';
$conf['404_fast_html'] = '<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML+RDFa 1.0//EN\" \"http://www.w3.org/MarkUp/DTD/xhtml-rdfa-1.dtd\"><html xmlns=\"http://www.w3.org/1999/xhtml\"><head><title>404 Not    Found</title></head><body><h1>Not Found</h1><p>The requested URL \"@path\" was not found on this server.</p></body></html>';
# drupal_fast_404();

# $conf['proxy_user_agent'] = ;
# $conf['proxy_exceptions'] = array('127.0.0.1', 'localhost');

error_reporting(E_ALL);
ini_set('display_errors', TRUE);
ini_set('display_startup_errors', TRUE);

ini_set('memory_limit', '128M');
