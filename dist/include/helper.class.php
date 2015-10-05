<?php
class Helper {
  static function createSassConfig($hColors) {
    $sFileContent = <<<SASS
  \$color-main: {$hColors['main']};
  \$color-accent: {$hColors['accent']};
  \$color-darkmode: {$hColors['darkmode']};
SASS;

    file_put_contents("dist/settings/colors.scss", $sFileContent);
  }
}
