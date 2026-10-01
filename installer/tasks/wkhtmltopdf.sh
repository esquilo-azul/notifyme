#!/bin/bash

set -u
set -e

export WKHTMLTOPDF_PACKAGE='wkhtmltopdf'

function task_condition {
  package_installed apt "$WKHTMLTOPDF_PACKAGE"
}

function task_fix {
  package_assert apt "$WKHTMLTOPDF_PACKAGE"
}
