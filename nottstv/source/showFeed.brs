'**********************************************************
'**  Video Player Example Application - Show Feed 
'**  November 2009
'**  Copyright (c) 2009 Roku Inc. All Rights Reserved.
'**********************************************************

'******************************************************
'** Set up the show feed connection object
'** This feed provides the detailed list of shows for
'** each subcategory (categoryLeaf) in the category
'** category feed. Given a category leaf node for the
'** desired show list, we'll hit the url and get the
'** results.     
'******************************************************

Function InitShowFeedConnection(category As Object) As Object

    if validateParam(category, "roAssociativeArray", "initShowFeedConnection") = false return invalid 

    conn = CreateObject("roAssociativeArray")
    conn.UrlShowFeed  = category.feed 

    conn.Timer = CreateObject("roTimespan")

    conn.LoadShowFeed    = load_show_feed
    conn.ParseShowFeed   = parse_show_feed
    conn.InitFeedItem    = init_show_feed_item

    print "created feed connection for " + conn.UrlShowFeed
    return conn

End Function


'******************************************************
'Initialize a new feed object
'******************************************************
Function newShowFeed() As Object

    o = CreateObject("roArray", 100, true)
    return o

End Function


'***********************************************************
' Initialize a ShowFeedItem. This sets the default values
' for everything.  The data in the actual feed is sometimes
' sparse, so these will be the default values unless they
' are overridden while parsing the actual game data
'***********************************************************
Function init_show_feed_item() As Object
    o = CreateObject("roAssociativeArray")

    o.ContentId        = ""
    o.Title            = ""
    o.ContentType      = ""
    o.ContentQuality   = ""
    o.Synopsis         = ""
    o.Genre            = ""
    o.Runtime          = ""
    o.StreamQualities  = CreateObject("roArray", 5, true) 
    o.StreamBitrates   = CreateObject("roArray", 5, true)
    o.StreamUrls       = CreateObject("roArray", 5, true)

    return o
End Function


'*************************************************************
'** Grab and load a show detail feed. The url we are fetching 
'** is specified as part of the category provided during 
'** initialization. This feed provides a list of all shows
'** with details for the given category feed.
'*********************************************************
Function load_show_feed(conn As Object) As Dynamic

    if validateParam(conn, "roAssociativeArray", "load_show_feed") = false return invalid 

    print "url: " + conn.UrlShowFeed 
    http = NewHttp(conn.UrlShowFeed)

    m.Timer.Mark()
    rsp = http.GetToStringWithRetry()
    print "Request Time: " + itostr(m.Timer.TotalMilliseconds())

    feed = newShowFeed()
    xml=CreateObject("roXMLElement")
    if not xml.Parse(rsp) then
        print "Can't parse feed"
        return feed
    endif

    if xml.GetName() <> "rss" then
        print "no rss tag found"
        return feed
    endif

    if islist(xml.GetBody()) = false then
        print "no channel body found"
        return feed
    endif

    m.Timer.Mark()
    m.ParseShowFeed(xml, feed)
    print "Show Feed Parse Took : " + itostr(m.Timer.TotalMilliseconds())

    return feed

End Function


'**************************************************************************
'**************************************************************************
Function parse_show_feed(xml As Object, feed As Object) As Void

    showCount = 0
    ashowList = xml.GetChildElements()

    for each curArr in ashowList
		print "Found " + curArr.GetName()
		if curArr.GetName() = "channel" then
			showList = curArr.GetChildElements()
			for each curShow in showList	
				'for now, don't process meta info about the feed size
				if curShow.GetName() = "item" then
					item = init_show_feed_item()
					'fetch all values from the xml for the current show
					item.hdImg            = validstr(curShow.GetNamedElements("media:thumbnail")[0]@url) 
					item.sdImg            = validstr(curShow.GetNamedElements("media:thumbnail")[0]@url) 
					item.ContentId        = validstr(curShow.guid.GetText()) 
					item.Title            = validstr(curShow.title.GetText()) 
					item.Description      = validstr(curShow.description.GetText()) 
					item.ContentType      = "TV"
					item.ContentQuality   = "SD"
					item.Synopsis         = validstr(curShow.description.GetText())
					item.Genre            = validstr(curShow.genres.GetText())
					item.Runtime          = "0"
					item.HDBifUrl         = validstr(curShow.hdBifUrl.GetText())
					item.SDBifUrl         = validstr(curShow.sdBifUrl.GetText())
					item.StreamFormat = "mp4"
					
					'map xml attributes into screen specific variables
					item.ShortDescriptionLine1 = item.Title 
					item.ShortDescriptionLine2 = item.Description
					item.HDPosterUrl           = item.hdImg
					item.SDPosterUrl           = item.sdImg

					item.Length = strtoi(item.Runtime)
					item.Categories = CreateObject("roArray", 5, true)
					item.Categories.Push(item.Genre)
					item.Actors = CreateObject("roArray", 5, true)
					item.Actors.Push(item.Genre)
					item.Description = item.Synopsis
					
					'Set Default screen values for items not in feed
					item.HDBranded = false
					item.IsHD = false
					item.StarRating = "90"
					item.ContentType = "episode" 
					item.StreamUrls.Push("http://kjs.me.uk/nottstv/r?id=" + validstr(curShow.guid.GetText()))					
					item.StreamQualities.push("sd")
					item.StreamBitrates.push(1500)

					showCount = showCount + 1
					feed.Push(item)
				else
					print "skip " + curShow.GetName()
				endif
			next
		endif
    next

End Function
