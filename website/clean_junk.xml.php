<?php
$url = "http://api.brightcove.com/services/library?command=search_videos&token=1N4JCL3KisuyvNlDIPdrJGpatQ1dVXuaCRtD88vFyCqx6Va1G_yGtg..&video_fields=id,name,videoStillURL,tags&sort_by=start_date:desc&{$_GET['anyall']}={$_GET['field']}:{$_GET['tag']}&output=mrss&";
$out = file_get_contents($url);


$out = preg_replace('/[^(\x20-\x7F)]*/','', $out);
echo $out;

echo "<!-- {$url} -->";
?>