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
define( 'DB_USER', 'wordpress' );

/** MySQL database password */
define( 'DB_PASSWORD', 'wordpress' );

/** MySQL hostname */
define( 'DB_HOST', 'mysql' );

/** Database Charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );

/** The Database Collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

define('WP_HOME', 'http://wordpress.local:8080');
define('WP_SITEURL', 'http://wordpress.local:8080');

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

define('AUTH_KEY',         '=7NVnmr8Am+3inGM=pPlNb(YD`kgG3vd~_]V-t.awA!VI2!AkLj2l<Xb0MB O-n|');
define('SECURE_AUTH_KEY',  '$hF-O*--._j|V)zU2V||LKDlBdN${7XXTQHQUj{3xI-Ne`z=LK/1`n|{;Wbp-dY}');
define('LOGGED_IN_KEY',    'o2)x_xV4@<6n?U)]ONu(i`bI=qk;^7kLaV5|OAu{E?J;~_M`S+xMFn1Y(qc[|8AF');
define('NONCE_KEY',        '`hVy?D7!STjwD-%nc0N9-Pe&-&YBPxJapDM{rV[MW][i5wF})0GfTvTIfAfT#0z`');
define('AUTH_SALT',        'lxnGjwIqM:&Ag}e$W/OGLCB]:*s+<7}w2,9uYD0N0&jt<TV`d$=G}{j~lo!+iV_d');
define('SECURE_AUTH_SALT', '>?K|k6Q5dE[5T`)}n.FOf-sd|+SIPp7<lgzT$bEu4t,6)pbukNrb#q!I-&+D0Jpd');
define('LOGGED_IN_SALT',   '|4b(1q~e]*Y]GXZdv]>jE8z~b[c-bHQvd,79[X=RaQF|CkLPHaz2:oN!mL+heA$S');
define('NONCE_SALT',       'f/JGPc0bK[Q<x4FCR|..^n_2V!suVf+*_=!a^tQ>2so~u*s2yf/_+=WAGU6Tz}sC');


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
define( 'WP_DEBUG_DISPLAY', true );

/* That's all, stop editing! Happy blogging. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) )
	define( 'ABSPATH', dirname( __FILE__ ) . '/' );

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';
