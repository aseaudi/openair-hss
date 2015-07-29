################################################################################
#    OpenAirInterface
#    Copyright(c) 1999 - 2014 Eurecom
#
#    (at your option) any later version.
#
#
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#
#    along with OpenAirInterface.The full GNU General Public License is
#
#  Contact Information
#  OpenAirInterface Admin: openair_admin@eurecom.fr
#  OpenAirInterface Tech : openair_tech@eurecom.fr
#  OpenAirInterface Dev  : openair4g-devel@eurecom.fr
#
#  Address      : Eurecom, Compus SophiaTech 450, route des chappes, 06451 Biot, France.
#
################################################################################

# ARG is REALM
# BY DEFAULT REALM IS "eur"

DEFAULTREALMVALUE="eur"
REALM=${1:-$DEFAULTREALMVALUE}

rm -rf demoCA
mkdir demoCA
echo 01 > demoCA/serial
touch demoCA/index.txt

user=$(whoami)
HOSTNAME=$(hostname -f)

echo "Creating HSS certificate for user '$HOSTNAME'.'$REALM'"
# 
# # CA self certificate
# openssl req  -new -batch -x509 -days 3650 -nodes -newkey rsa:1024 -out cacert.pem -keyout cakey.pem -subj /CN=test.fr/C=FR/ST=Biot/L=Aix/O=test.fr/OU=mobiles
# 
# openssl genrsa -out hss.key.pem 1024
# openssl req -new -batch -out hss.csr.pem -key hss.key.pem -subj /CN=hss.test.fr/C=FR/ST=Biot/L=Aix/O=test.fr/OU=mobiles
# openssl ca -cert cacert.pem -keyfile cakey.pem -in hss.csr.pem -out hss.cert.pem -outdir . -batch

# Create a Root Certification Authority Certificate
openssl req  -new -batch -x509 -days 3650 -nodes -newkey rsa:1024 -out hss.cacert.pem -keyout hss.cakey.pem -subj /CN=$REALM/C=FR/ST=PACA/L=Aix/O=Eurecom/OU=CM

# Generate a Private Key
openssl genrsa -out hss.key.pem 1024

# Generate a CSR (Certificate Signing Request) that will be self-signed
openssl req -new -batch -out hss.csr.pem -key hss.key.pem -subj /CN=$HOSTNAME.$REALM/C=FR/ST=PACA/L=Aix/O=Eurecom/OU=CM

# Certification authority
openssl ca -cert hss.cacert.pem -keyfile hss.cakey.pem -in hss.csr.pem -out hss.cert.pem -outdir . -batch

if [ ! -d /usr/local/etc/freeDiameter ]
then
    echo "Creating non existing directory: /usr/local/etc/freeDiameter/"
    sudo mkdir /usr/local/etc/freeDiameter/
fi

sudo cp -upv hss.cakey.pem hss.cert.pem hss.cacert.pem hss.key.pem /usr/local/etc/freeDiameter/

# openssl genrsa -out $hss.key.pem 1024
# openssl req -new -batch -out $hss.csr.pem -key $hss.key.pem -subj /CN=$hss.test.fr/C=FR/ST=Biot/L=Aix/O=test.fr/OU=mobiles
# openssl ca -cert cacert.pem -keyfile cakey.pem -in $hss.csr.pem -out $hss.cert.pem -outdir . -batch