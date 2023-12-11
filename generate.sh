#!/bin/bash

template=$(cat README_TEMPLATE.md)
content_table_string=""
templates_string=""

for file in ./templates/*
do
    filename=$(basename $file)
    filename=${filename%.*}
    lower_filename=$(echo $filename | tr '[:upper:]' '[:lower:]')

    content_table_string="$content_table_string\n - [$filename](#$lower_filename)"
    templates_string="$templates_string\n## $filename\n\`\`\`dockerfile\n$(cat $file)\n\`\`\`\n"
done

readme="${template//\{\{TABLE\}\}/$content_table_string}"
readme="${readme//\{\{FILES\}\}/$templates_string}"
readme="${readme//\\n/$'\n'}"

echo "$readme" > README.md
