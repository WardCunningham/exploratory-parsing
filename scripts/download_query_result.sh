cd data
rm -rf query-result
curl https://chi-hudson.newrelic.com/job/MGI-Explorer/ws/mgi-explorer/query-result/*zip*/query-result.zip >query-result.zip
unzip query-result.zip
rm query-result.zip
