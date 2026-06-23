<?php
defined('BASEPATH') OR exit('No direct script access allowed');

/*
|--------------------------------------------------------------------------
| LAUFEY — Route Configuration
|--------------------------------------------------------------------------
*/

$route['default_controller'] = 'Catalog';
$route['404_override']       = 'Errors/not_found';
$route['translate_uri_dashes'] = FALSE;

// ── Auth ──────────────────────────────────────────────────
$route['login']             = 'Auth/login';
$route['login/POST']        = 'Auth/do_login';
$route['register']          = 'Auth/register';
$route['register/POST']     = 'Auth/do_register';
$route['logout']            = 'Auth/logout';

// ── Catalog / Home ────────────────────────────────────────
$route['']                  = 'Catalog/index';
$route['catalog']           = 'Catalog/index';
$route['catalog/search']    = 'Catalog/search';
$route['catalog/genre/(:num)'] = 'Catalog/by_genre/$1';

// ── Player / Streaming ────────────────────────────────────
$route['stream/play/(:num)']  = 'Stream/play/$1';          // audio stream endpoint
$route['song/lyrics/(:num)']  = 'Stream/lyrics/$1';        // AJAX lyrics fetch

// ── Download ──────────────────────────────────────────────
$route['download/(:num)']   = 'Download/get/$1';

// ── User Profile & Personalization ────────────────────────
$route['profile']                    = 'Profile/index';
$route['profile/theme']              = 'Profile/theme';
$route['profile/theme/save']         = 'Profile/save_theme';
$route['profile/history']            = 'Profile/history';
$route['playlist']                   = 'Playlist/index';
$route['playlist/create']            = 'Playlist/create';
$route['playlist/(:num)']            = 'Playlist/view/$1';
$route['playlist/(:num)/add/(:num)'] = 'Playlist/add_song/$1/$2';
$route['playlist/(:num)/remove/(:num)'] = 'Playlist/remove_song/$1/$2';
$route['playlist/(:num)/delete']     = 'Playlist/delete/$1';
$route['favorites']                  = 'Favorites/index';
$route['favorites/toggle/(:num)']    = 'Favorites/toggle/$1';

// ── Admin Panel ───────────────────────────────────────────
$route['admin']                      = 'Admin/dashboard';
$route['admin/songs']                = 'Admin/songs';
$route['admin/songs/add']            = 'Admin/add_song';
$route['admin/songs/add/POST']       = 'Admin/do_add_song';
$route['admin/songs/edit/(:num)']    = 'Admin/edit_song/$1';
$route['admin/songs/edit/(:num)/POST'] = 'Admin/do_edit_song/$1';
$route['admin/songs/delete/(:num)']  = 'Admin/delete_song/$1';
$route['admin/users']                = 'Admin/users';
$route['admin/users/toggle/(:num)']  = 'Admin/toggle_user/$1';
$route['admin/users/delete/(:num)']  = 'Admin/delete_user/$1';