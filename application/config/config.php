<?php
defined('BASEPATH') OR exit('No direct script access allowed');

/*
|--------------------------------------------------------------------------
| Base Site URL — LAUFEY
|--------------------------------------------------------------------------
| Sesuaikan dengan environment lokal kamu.
| Contoh: http://localhost/laufey/
*/
$config['base_url'] = 'http://localhost/Laufey_Project_UAS_PWEB/';

$config['index_page'] = '';   // kosong jika pakai .htaccess mod_rewrite

$config['uri_protocol']    = 'REQUEST_URI';
$config['url_suffix']      = '';
$config['language']        = 'english';
$config['charset']         = 'UTF-8';
$config['enable_hooks']    = FALSE;
$config['subclass_prefix'] = 'MY_';
$config['composer_autoload'] = FALSE;
$config['permitted_uri_chars'] = 'a-z 0-9~%.:_\-';

/*
|--------------------------------------------------------------------------
| Class Extension Prefix
|--------------------------------------------------------------------------
*/
$config['enable_query_strings'] = FALSE;
$config['controller_trigger']   = 'c';
$config['function_trigger']     = 'm';
$config['directory_trigger']    = 'd';

$config['log_threshold'] = 0;
$config['log_path']      = '';
$config['log_file_extension'] = '';
$config['log_file_permissions'] = 0644;
$config['log_date_format']   = 'Y-m-d H:i:s';

$config['error_views_path'] = '';

$config['cache_path'] = '';

$config['encryption_key'] = 'L4uf3y_S3cr3t_K3y_2026_UBG';

$config['sess_driver']          = 'database';
$config['sess_cookie_name']     = 'laufey_session';
$config['sess_expiration']      = 7200;
$config['sess_save_path']       = 'ci_sessions';   // tabel di DB
$config['sess_match_ip']        = FALSE;
$config['sess_time_to_update']  = 300;
$config['sess_regenerate_destroy'] = FALSE;

$config['cookie_prefix']   = 'laufey_';
$config['cookie_domain']   = '';
$config['cookie_path']     = '/';
$config['cookie_secure']   = FALSE;
$config['cookie_httponly']  = FALSE;

$config['standardize_newlines'] = FALSE;
$config['global_xss_filtering'] = FALSE;
$config['csrf_protection']  = TRUE;
$config['csrf_token_name']  = 'laufey_csrf';
$config['csrf_cookie_name'] = 'laufey_csrf';
$config['csrf_expire']      = 7200;
$config['csrf_regenerate']  = TRUE;
$config['csrf_exclude_uris'] = array(
    'stream/play',          // streaming endpoint bypass CSRF
    'download/get',
);

$config['compress_output'] = FALSE;
$config['time_reference']  = 'local';
$config['rewrite_short_tags'] = FALSE;

$config['proxy_ips'] = '';

// ---- Konstanta Aplikasi ----
$config['guest_play_limit']     = 3;    // maks putar per sesi tamu
$config['guest_download_limit'] = 1;    // maks unduh per hari tamu
$config['audio_upload_path']    = FCPATH . 'assets/audio/';
$config['cover_upload_path']    = FCPATH . 'assets/img/covers/';
$config['allowed_audio_types']  = 'audio/mpeg|audio/ogg|audio/wav';
$config['allowed_image_types']  = 'image/jpeg|image/png|image/webp';
$config['max_audio_size']       = 30720;   // 30 MB dalam KB
$config['max_cover_size']       = 2048;    // 2 MB dalam KB