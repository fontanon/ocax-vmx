# Default host ip. You should set this on your host machine /etc/hosts file
# WARNING: Make sure this ip is correctly set on Vagrantfile private network param too!
default[:ocax][:host_ip] = "192.168.56.101"

# Default hostname. You should set this on your host machine /etc/hosts file
default[:ocax][:host_name] = "ocax.dev"

# OCAX source files, installation path, virtualhostname ...
default[:ocax][:virtualhost_name] = "node"
default[:ocax][:download_cache] = "/tmp/ocax-1.1.2.tar.gz"
default[:ocax][:download_url] = "http://ocax.net/download/ocax-1.1.2.tar.gz"
default[:ocax][:download_checksum] = "0f8f132fc274ccfe061ebd5796a094fed90456f1c954084aa022e6f4fc9d2eda" # SHA256
default[:ocax][:installpath] = "/var/www/ocax"

# OCAX MySQL credentials
default[:ocax][:mysql_user] = "ocax"
default[:ocax][:mysql_password] = "ocax"
default[:ocax][:mysql_dbname] = "ocax"

# Spanish budget structure mysql data
default[:ocax][:spanishbudget_download_url] = "http://ocax.net/download/budgetdescriptions/spain_budget_description.sql"
default[:ocax][:spanishbudget_download_cache] = "/tmp/spain_budget_description.sql"
default[:ocax][:spanishbudget_download_checksum] = "a7f4e6aa2f83b2a78b08c7f7f896e5867178adf5c4722e962fa250b7e36d95de" # SHA256

# Yii framework (ocax dependency)
default[:ocax][:yii_download_cache] = "/tmp/yii-1.1.14.f0fee9.tar.gz"
default[:ocax][:yii_download_url] = "https://github.com/yiisoft/yii/releases/download/1.1.14/yii-1.1.14.f0fee9.tar.gz"
default[:ocax][:yii_download_checksum] = "950f3499d6879aa8d8264bbef35a1d67d3f1cc6dcd41fe7c5ada2910e07ed053" # SHA256
default[:ocax][:yii_installpath] = "/var/www/ocax"