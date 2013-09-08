<?php
 
 $db_url = 'mysql://VAGRANT:VAGRANT@localhost/VAGRANT';
 # $db_prefix = ;
 
 $update_free_access = FALSE;
 
 ini_set('arg_separator.output',     '&');
 ini_set('magic_quotes_runtime',     0);
 ini_set('magic_quotes_sybase',      0);
 ini_set('session.cache_expire',     200000);
 ini_set('session.cache_limiter',    'none');
 ini_set('session.cookie_lifetime',  2000000);
 ini_set('session.gc_maxlifetime',   200000);
 ini_set('session.save_handler',     'user');
 ini_set('session.use_cookies',      1);
 ini_set('session.use_only_cookies', 1);
 ini_set('session.use_trans_sid',    0);
 ini_set('url_rewriter.tags',        '');
 
 # $conf = array(
 #   'site_name' => 'My Drupal site',
 #   'theme_default' => 'minnelli',
 #   'anonymous' => 'Visitor',
 
 #   'maintenance_theme' => 'minnelli',
 
 # General caching settings
 $conf['cache'] = 1;
 $conf['block_cache'] = 1;
 $conf['cache_lifetime'] = 600;
 $conf['page_cache_maximum_age'] = 600;
 $conf['page_compression'] = 1;
 $conf['preprocess_css'] = 1;
 $conf['preprocess_js'] = 1;

error_reporting(E_ALL);
ini_set('display_errors', TRUE);
ini_set('display_startup_errors', TRUE);

ini_set('memory_limit', '128M');
