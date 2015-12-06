<?
header("Content-type: text/xml;");
echo '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>';

$cats["the-630-show"] 			=  "6:30 Show";
$cats["the-boot-room-fan-zone"] =  "The Boot Room - Fan Zone";
$cats["the-boot-room-pro-zone"] =  "The Boot Room - Pro Zone";
$cats["channel-8-debate"] 		=  "Channel 8 Debate";
$cats["day-in-the-life"] 		=  "Day in the Life";
$cats["digital-nation"] 		=  "Digital Nation";
$cats["inside-industry-week"] 	=  "Inside Industry Week";
$cats["the-locker-room"] 		=  "The Locker Room";
$cats["now-and-then"] 			=  "Nottingham Now and Then";
$cats["mass-bolero"] 			=  "Mass Bolero";
$cats["noise-floor"] 			=  "Noise Floor";
$cats["sounding-out"] 			=  "Sounding Out";
$cats["working-week"] 			=  "Working Week";
$cats["current-affairs"] 		=  ">> Current Affairs";
$cats["entertainment"] 			=  ">> Entertainment";
$cats["lifestyle"] 				=  ">> Lifestyle";
$cats["music"] 					=  ">> Music";
$cats["news"] 					=  ">> News";
$cats["sport"] 					=  ">> Sport";
 
echo "<categories>";
foreach($cats as $tag=>$label)
{
	if (in_array($tag,array('the-630-show',"sport","entertainment","music","lifestyle")))
	{
		$stag = str_replace("-","%20",$tag);
		$url = "http://api.brightcove.com/services/library?command=search_videos&amp;token=1N4JCL3KisuyvNlDIPdrJGpatQ1dVXuaCRtD88vFyCqx6Va1G_yGtg..&amp;video_fields=id,name,videoStillURL,tags&amp;sort_by=start_date:desc&amp;all=tag:{$stag}&amp;output=mrss";
	}
	elseif(in_array($tag,array('current-affairs')))
	{
		$stag = str_replace("-","%20",$tag);
		$url = "http://kjs.me.uk/nottstv/clean_junk.xml.php?tag={$stag}&amp;field=tag&amp;anyall=all";
	}
	elseif(in_array($tag,array('channel-8-debate')))
	{
		$stag = str_replace("-"," ",$tag);
		$stag = $tag;
		
		$url = "http://kjs.me.uk/nottstv/clean_junk.xml.php?tag={$tag}&amp;field=custom_fields&amp;anyall=any";
	}
	else
	{
		$url = "http://api.brightcove.com/services/library?command=search_videos&amp;token=1N4JCL3KisuyvNlDIPdrJGpatQ1dVXuaCRtD88vFyCqx6Va1G_yGtg..&amp;video_fields=id,name,videoStillURL,tags&amp;sort_by=start_date:desc&amp;any=custom_fields:{$tag}&amp;output=mrss";
	}
	?>
	<category title="<?=$label?>" description="" sd_img="http://kjs.me.uk/nottstv/<?=$tag?>.png" hd_img="http://kjs.me.uk/nottstv/<?=$tag?>.png">
		<categoryLeaf title="<?=$label?>" description="" feed="<?=$url?>"/>
	</category>
	<?
}
?>
</categories>
