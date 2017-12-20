<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the
 * installation. You don't have to use the web site, you can
 * copy this file to "wp-config.php" and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * MySQL settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://codex.wordpress.org/Editing_wp-config.php
 *
 * @package WordPress
 */

// ** MySQL settings ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'eyes_on_the_ties' );

/** MySQL database username */
define( 'DB_USER', 'wp_blog' );

/** MySQL database password */
define( 'DB_PASSWORD', 'password' );

/** MySQL hostname */
define( 'DB_HOST', 'mysql' );

/** Database Charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );

/** The Database Collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

define('WP_HOME','http://localhost:8081');
define('WP_SITEURL','http://localhost:8081');
define( 'WP_MEMORY_LIMIT', '256M' );
/**
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         'u68L])MyrC#X|4d+x6Yvs*<EI:{):k,j:N1KFw:k]1k(8gHOB!vg$95V58HYCJFI');
define('SECURE_AUTH_KEY',  'f& O!.RTM7uX|o3QZbg1)g4]P-=IvL3rp,{/5a 9<J6:H=O:uJ%Uv+vz0NgQRrNG');
define('LOGGED_IN_KEY',    'r0-dZ!^F?yt/YtQQ3;h):pogOFo/2VWX6oh%~hwx/#iinb){r%ZiJD-H-9{KhIz0');
define('NONCE_KEY',        '4y`Xbm@^e|x+OFq^GCesTVZPqsm.=i=A&!UZRCN_cCA<i*|d-A&`NA:jxG0WpW--');
define('AUTH_SALT',        'p+tBW0XU~@{B;QRcoB1^7Dt*9zi,,($K9/7QLT=Vy`sCMAF~]-!IJ6ed~z[T:qka');
define('SECURE_AUTH_SALT', 'nJ*6W7rya~AyF|`5#W<l|q+JHR/`$M-W| mS^,K}zB-8ME%-j9uG):dPnWS{r3Sb');
define('LOGGED_IN_SALT',   '+Jg@{cve,>_?`y+6x^TlU2J@FmD/G#qLf&}.oy|m?8h3IDsZH&A8X:t>$@HShI w');
define('NONCE_SALT',       'a+oRsQ[lmm~Y6SD0(o>}8j*aW&j|CcTrd&,6bI4s/%~/,j@Nqe_:OG]Mu5}/|k-c');


/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix = 'wp_';


/* Debugging */
define( 'WP_DEBUG', true );
define( 'WP_DEBUG_LOG', true );
define( 'WP_DEBUG_DISPLAY', false );

/* That's all, stop editing! Happy blogging. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) )
	define( 'ABSPATH', dirname( __FILE__ ) . '/' );

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';
