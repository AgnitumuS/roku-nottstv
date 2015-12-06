<?
$id = $_REQUEST['id'];

$url = "http://api.brightcove.com/services/library?command=find_video_by_id&video_id=" . $id . "&video_fields=name,length,renditions&token=1N4JCL3KisuyvNlDIPdrJGpatQ1dVXuaCRtD88vFyCqx6Va1G_yGtg..&sort_by=encodingRate:asc";
$j = json_decode(file($url));
print_r($j);

?>