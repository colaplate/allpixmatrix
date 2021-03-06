
//=============================================================================================================

//Called every time a new frame is available to read
//NEW: Changed method doesn't read() the frame until needed by the layer mixing
/*
void movieEvent(Movie m) {
	try {
	m.read(); //how could it error if it just called the event, but it has
	}
	catch(Exception e)
	{
	println("Movie Event Error - let it go");
	}
}
*/
//=============================================================================================================

void serialEvent(Serial p) 
{ 
  int rxByte;
  
  if(p == serialPort)
  {
   rxByte = p.read(); 
	 //println("responds on serial output. "+rxByte+"   "+char(rxByte));
	 //aurora will "zAck" packets, that can be ignored or use for a heartbeat to monitor the serial port
   return;
  }

   while (p.available() > 0)
   {
    rxByte = p.read(); 
  
	  //Code for glediator only as of now
	  if(ExternalDataFramed == true && ExternalDataArray.length > 1) //if 1 or less its not yet inialized
	  {
		//println("RX: "+rxByte+"   Counter: "+ExternalDataCounter);
		
		//if(rxByte == 1) println("This happened");
		//else 
		ExternalDataArray[ExternalDataCounter] = (short)rxByte; //store received value
		
		ExternalDataCounter++;
		if(ExternalDataCounter >= ((matrix.width * matrix.height)*3)) 
		{
		// println("reset counter, received: "+ExternalDataCounter);
		 ExternalDataCounter = 0;
		 ExternalDataFramed = false;
		}
	  }
	  else if(rxByte == 1) 
	  {
	   // println("Frame detected "+millis());
		ExternalDataMillis = (millis()-ExternalDataHoldMillis); //monitors the packet speed for display on the GUI
		ExternalDataHoldMillis = millis(); //update after saving packet timing
		ExternalDataFramed = true;
	  }
   } //end while
} //end serial event

//================================================================================================================
