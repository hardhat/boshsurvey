# boshsurvey
Uses graphviz to make a chart of your current bosh deployments

Usage:

ssh -i credentials/credentials_jumpbox.pem ubuntu@hostname boshsurvey/src/boshsurvey.rb | dot -Tpdf -o test.pdf
