/**
 * @function string_datetime
 * @description	Get the date in the format:: year/month/day, hour:minute:second AM/PM
 * @memberof Kengine.fn.strings
 * @return {String}
 *
 */
function string_datetime() {
	/*
	    gets the date in the format:: year/month/day, hour:minute:second AM/PM
	        Eg:: 2006/08/05, 11:48:15 PM
	    Arguments:: [N/A]
    
	    Return:: the date/time
	*/
	var date,year,month,day,hour,minute,second,time,result;

	date = date_current_datetime()
	        //Get elements of date/time

	    //get year
	year = date_get_year(date)
	year = string(year)

	    //get month
	month = date_get_month(date)
	month = string(month)

	    //get date
	day = date_get_day(date)
	day = string(day)

	    //get hour
	hour = date_get_hour(date)
	if (hour < 10)
	    hour = "0" + string(hour)
	else
	    hour = string(hour)

	    //get minute
	minute = date_get_minute(date)
	if (minute < 10)
	    minute = "0" + string(minute)
	else
	    minute = string(minute)

	    //get second
	second = date_get_second(date)
	if (second < 10)
	    second = "0" + string(second)
	else
	    second = string(second)

	        //return the date
        
	date = year + "/" + month + "/" + day + ", "
	time = hour + ":" + minute + ":" + second
	result = date + time

	return result	
}
