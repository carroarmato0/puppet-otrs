# == Class otrs::database
#
# This class is called from otrs for managing the database.
#
class otrs::database {

  $override_options = {
    'mysqld' => {
      'max_allowed_packet'   => '20MB',
      'innodb_log_file_size' => '256MB',
    }
  }

  class { '::mysql::server':
    remove_default_accounts => true,
    override_options        => $override_options,
    restart                 => true,
  }

  mysql::db { $::otrs::db_name:
    user     => $::otrs::db_user,
    password => $::otrs::db_password,
    host     => $::otrs::db_host,
    grant    => ['ALL'],
  }

}
