# Default host ip. You should set this on your host machine /etc/hosts file
# WARNING: Make sure this ip is correctly set on Vagrantfile private network param too!
default[:ocax][:host_ip] = "192.168.56.101"

# Default hostname. You should set this on your host machine /etc/hosts file too.
default[:ocax][:host_name] = "ocax.dev"

# OCAx virtualhostname.
default[:ocax][:virtualhost_name] = "node"

# OCAx download and install paths
default[:ocax][:gitrepo_uri] = "https://git.gitorious.org/ocax/ocax.git"
default[:ocax][:installpath] = "/var/www/ocax"

# Yii framework (OCAx dependency)
default[:ocax][:yii_download_cache] = "/tmp/yii-1.1.14.f0fee9.tar.gz"
default[:ocax][:yii_download_url] = "https://github.com/yiisoft/yii/releases/download/1.1.14/yii-1.1.14.f0fee9.tar.gz"
default[:ocax][:yii_download_checksum] = "950f3499d6879aa8d8264bbef35a1d67d3f1cc6dcd41fe7c5ada2910e07ed053" # SHA256
default[:ocax][:yii_installpath] = "/var/www/ocax"

# OCAx MySQL credentials
default[:ocax][:mysql_user] = "ocax"
default[:ocax][:mysql_password] = "ocax"
default[:ocax][:mysql_dbname] = "ocax"

# Spanish budget structure mysql data
default[:ocax][:spanishbudget_download_url] = "http://ocax.net/download/budgetdescriptions/spain_budget_description.sql"
default[:ocax][:spanishbudget_download_cache] = "/tmp/spain_budget_description.sql"
default[:ocax][:spanishbudget_download_checksum] = "a7f4e6aa2f83b2a78b08c7f7f896e5867178adf5c4722e962fa250b7e36d95de" # SHA256

# Default OCAx admin credentials
default[:ocax][:adminaccount_username] = "admin"
default[:ocax][:adminaccount_password] = "admin"
default[:ocax][:adminaccount_email] = "cambia_este@email.ya"
