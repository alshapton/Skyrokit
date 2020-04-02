-- title:  Skyrokit
-- author: Andrew Shapton
-- desc:   Fly your missions!
-- script: lua
-- saveid: Skyrokit-SAVE 

-- ================================== --
-- S T A R T   O F  F U N C T I O N S --
-- ================================== --

function startup()
 sound_on     = 1
 music_on     = 1
 version      = "0.1"
 starlimit    = 1
 seconds      = 0
 mins         = 0
 hours        = 0
 dseconds     = 0
 dmins        = 0
 dhours       = 0
 timeinflight = 0
	
 Phiscore = pmem(0) -- persistent memory hiscore
 Psound   = pmem(1) -- persistent memory score
 Pmusic   = pmem(2) -- persistent memory music

 
 heatframe  = 0
 orange     = 9
 red        = 6
 heatcolour = orange
 fuel       = 130    -- how much fuel we start  with
 

 st        = 0
 tx        = 240
 stars     = {}      -- stars array
 fill_stars()        -- populate stars array

 in_game   = -1      -- not started game yet
 
	-- Initialise rocket
 rocket = {
	          t        = 266, -- sprite ID of rocket
	          x        = 96,  -- x position of rocket
	          y        = 82,  -- y position of rocket
	          inflight = 0,   -- rocket is flying
         		finsyl   = 0,   -- y position of fins
         		finsyr   = 0,   -- left and right
	         	finsxl   = 0,   -- x position of fins
	         	finsxr   = 0,   -- left and right           
    	      hasfins  = 1    -- rocket has fins
         	}
 

 rocket_start = rocket.y
 c            = 0         -- ticker before flame change
	
 fueltick     = 0         -- ticker before we lose a unit of fuel
 fueltop      = 10        -- top of fuel gauge
 fueluse      = 2         -- unit of fuel
 heattick     = 0         -- ticker for heat
 heatbottom   = 136       -- bottom of heat gauge
 heatuse      = 5         -- unit of heat
	
 show_pad         = 1     -- 1=show launchpad/0=dont show launchpad
 played_eog_sound = 0     -- 0 or 1 - playing end of game sound ?
 launchtop        = 100

end

--- Starfield
--- Thanks to Gigatron for the Starfield

function fill_stars()
--- fill stars table 
 for i=0,100 do
		star = {		
			x  = math.random(0,240),
			y  = math.random(0,160),
			sp = math.random(1,3),-- speed
			color = math.random(0,15),
			size = math.random(1,2)
		 }
  stars[i]=star
	end
end

function dstars(limit,color) 
 counter=0
 for s,b in pairs(stars) do
	 if counter < limit then
			b.y = b.y + b.sp
			if b.y > 140 then	
				b.y=0 
			end
			thiscolor =0
			-- set  star colour
			if color ~= -1 then
			 thiscolor=color
			else
				thiscolor=b.color
			end
--else
			if b.size <=1 then
			 pix(b.x,b.y,thiscolor)
			else 
			 circ(b.x,b.y,b.size,thiscolor)
			end
		end
		counter=counter+1
	end
end

--- Starfield


-- play sound(or not)
function sound(snd,p1,p2,p3,p4,p5)
 if sound_on == 1 then
	 sfx(snd,p1,p2,p3,p4,p5)
 end
end


function launchpad()
 if rocket.inflight==1 then
  launchtop=launchtop-0.5 
 end

 if launchtop < 10 then
  show_pad=0
 else
  line(88,200-launchtop+35,134,200-launchtop+35,4)
  line(88,200-launchtop+34,134,200-launchtop+34,4)
  spr(0,104,230-launchtop,-1,2,1,0,1,1)  
  for i=226,170, -8 do
   spr(256,88,i-launchtop,-1,1,1,0,1,1)  
  end
  spr(257,96,200-launchtop+4,0,1,1,0,1,1)
  spr(257,104,200-launchtop+4,0,1,1,0,1,1)
  spr(258,96,200-launchtop-8,0,1,1,0,1,1)
  spr(259,96,200-launchtop+20,0,1,0,0,1,1)
  spr(259,92,200-launchtop+23,0,1,0,0,1,1)
  spr(259,86,200-launchtop+26,0,1,0,0,1,1)
  spr(272,70,200-launchtop+28,0,1,0,0,2,1)
 end
end



-- Start Screen
function startscreen()
			cls(8)
	 	spr(0,0,0,-1,1,0,0,15,15)
			spr(11,0,0,-1,1,0,0,1,1)
			spr(11,120,0,-1,1,0,0,4,8)
			spr(11,110,0,-1,1,0,0,4,8)
			spr(11,150,0,-1,1,1,0,4,8)
			spr(2,180,0,-1,1,1,0,2,6)
			spr(9,190,0,-1,1,1,0,2,6)
			spr(10,200,0,-1,1,1,0,2,6)
			spr(12,210,0,-1,1,1,0,2,6)
			spr(12,220,0,-1,1,1,0,2,6)
			spr(14,230,0,-1,1,1,0,2,6)
			spr(209,98,120,-1,1,1,0,2,1)
	 	spr(236,0,120,-1,1,1,0,1,1)
			spr(230,10,120,-1,4,1,0,2,1)
			spr(225,2,118,-1,1,0,0,2,1)
			spr(210,0,118,-1,1,0,0,1,1)
			spr(245,0,128,-1,1,0,0,2,1)
			spr(225,0,122,-1,1,0,0,2,1)
	  spr(210,74,115,-1,1,1,0,2,1)
			spr(228,74,120,-1,1,1,0,1,2)
			spr(240,84,119,-1,1,1,0,1,1)
			spr(252,102,124,-1,1,0,0,1,1)
			spr(200,112,126,-1,1,0,0,1,1)
			spr(209,111,130,-1,1,0,0,1,1)
			spr(225,98,128,-1,1,1,0,2,2)
			spr(251,90,118,-1,1,1,0,1,1)
			spr(245,85,121,-1,1,1,0,1,1)
			spr(245,85,128,-1,1,1,0,1,1)
			spr(245,80,120,-1,1,1,0,1,1)
			spr(245,80,128,-1,1,1,0,1,1)
			spr(245,90,122,-1,1,1,0,1,1)
			spr(245,90,128,-1,1,1,0,1,1)
			
			logo=2
			fortic80=4
			spr(480,logo,90,0,2,0,0,10,2)
			spr(482,logo+157,90,0,2,0,0,2,2)
			spr(490,logo+188,90,0,2,0,0,3,2)
	
			spr(493,fortic80,125,0,1,0,0,3,1)
			spr(509,fortic80+35,125,0,1,0,0,3,1)
			spr(510,fortic80+60,125,0,1,0,3,1,1)
			spr(479,fortic80+70,125,0,1,0,0,1,1)
			spr(494,fortic80+80,125,0,1,0,0,1,1)

			
			
			print ("High Score: "..tostring(Phiscore),80,60)
			
			print("Press <space> to continue",82,80)
		
			spr(478,120,125,0,1,0,0,1,1)


   print("Andrew Shapton 2020",130,126,15,false,1,false)
   print("V"..version,220,117,15,false,1,true)
   -- sound icon
			spr(289,15,2,15,1,0,0,1,2)
   -- music icon
			spr(288,2,2,15,1,0,0,1,2)


   --sound on/off
	  if keyp(24,1,1) then
			 sound_on = sound_on * -1
			end
			if sound_on == -1 then
			 print("Off",13,20,15,false,1,true)
		 else
			 print("On",15,20,15,false,1,true)
			end

   --music on/off
	  if keyp(26,1,1) then
			 music_on = music_on * -1
			end
			if music_on == -1 then
			 music()
				print("Off",1,20,15,false,1,true)
		 else
			 print("On",2,20,15,false,1,true)
			end

			-- start  game ?
	  if keyp(48,1,1) then
			 in_game=0
				if music_on == 1 then
	  	 music(0,0,0,true)
				end
			end   

end

-- ================================== --
--    E N D  O F  F U N C T I O N S   --
-- ================================== --

-- Startup
startup()

-- Background gradient
function SCN(line)
 poke(0x3fc2,line)
end

--- Main Loop (frame)
function TIC()
  -- clear display before frame
		cls(0)
		if in_game == -1 then
   startscreen()
		else		
		if in_game <2 then	
 		heatframe=heatframe+1	
  	if btnp(0,1,1) then
		  if in_game == 0 then
			  seconds = 0
			 end
			 in_game = 1 -- game is on
 		 rocket.inflight=1 
			 heattick=heattick+1	-- update heat ticker because fuel is being used
			 fueltick=fueltick+1	-- update fuel ticker because fuel is being used
    if seconds >= 60 then
				 dseconds = dseconds + 1
					seconds = 0
					if dseconds >=60 then
					 dmins=dmins+1
						dseconds=0
					end
					if dmins >=60 then
					 dhours=dhours+1
						dmins=0
					end
										
				else

				 timeinflight=timeinflight+1
     seconds = seconds + 1
	 	 end
				if rocket.y > 2 then
			  rocket.y=rocket.y-1
		  end 
		 else
			 if rocket.y < 82 then
			  rocket.y=rocket.y+1     
			 end 
		 end
		
 
		-- update	 tickers
		c=c+1
 		
	
		-- change flame sprite if required
		if c == 5 then
		 if rocket.t == 262 then
		 	rocket.t=266
		 else
		  rocket.t=262
		 end
		c=0
		end
  -- reduce fuel if required
		if fueltick >= 100 then
		 fuel = fuel - fueluse
			fueltop = fueltop + fueluse
			fueltick = 0
		end
  -- manage heat
		if heatframe >= 60 then
			if btnp(0,1,1) then
    heatbottom=heatbottom-heatuse
    else
				if heatbottom <= 137 then
     heatbottom=heatbottom+heatuse
				end		  
   end
			heatframe=0
			heattick = 0
		end		
		
		end
  -- Display (z-order)
		-- starfield
		if in_game <2 then
		  starlimit = timeinflight /100
				if starlimit >99 then
					starlimit=99
			 end
				if timeinflight > 500 then
 		  dstars(starlimit,-1) -- remember to change colours here.
		  end
		end
  -- set colour of heat
		if heatbottom <=26 then
		  heatcolour=red
			else
			 heatcolour=orange
		end
  
		-- rocket
  spr(rocket.t,rocket.x,rocket.y-1,0,1,0,0,4,10)
  
		if show_pad == 1 then
   spr(271,rocket.x,rocket.y+31,0,1,0,0,1,3)
   spr(271,rocket.x+23,rocket.y+31,0,1,1,0,1,3)
  else
		 spr(319,rocket.x,rocket.y+31,-1,1,0,0,1,3)
   spr(319,rocket.x+23,rocket.y+31,-1,1,1,0,1,3)
	  --detach fins
			if rocket.hasfins==1 then
				if sound_on == 1 then
 				sound(1,'D-5',120,0,15,0)
	 		 sound(1,'D-4',120,0,15,0)
				end
				rocket.hasfins=0
				rocket.finsyl=rocket.y+33
				rocket.finsyr=rocket.y+33
				rocket.finsxl=rocket.x
				rocket.finsxr=rocket.x+23	      	
			else
			if (rocket.finsyl <260 and rocket.finsyr <260) then
   if in_game ~= 2 then
    rocket.finsyl=rocket.finsyl+math.random()/8
    rocket.finsyr=rocket.finsyr+math.random()/8
    rocket.finsxl=rocket.finsxl-math.random()/8
    rocket.finsxr=rocket.finsxr+math.random()/8
	  end
			spr(271,rocket.finsxl,rocket.finsyl,0,1,0,0,1,3)
   spr(271,rocket.finsxr,rocket.finsyr,0,1,1,0,1,3)			 
			end	
			end
		end

		-- gauge background
		rect(220,10,20,126,4)
  -- fuel
  rect(230,fueltop,10,fuel,11)
  rectb(230,10,10,126,15)  
  -- heat
  rect(220,heatbottom,10,300,heatcolour)
  rectb(220,10,10,126,15)  
  rectb(220,10,10,20,15)   
  --labels
		print("H",222,2)
		print("F",232,2)

  -- Score
		if rocket.inflight == 1 then
		 if in_game ~= 2 then
 
				outputh=tostring(dhours) .. "h"
			 if dhours <10 then
				 outputh="0"..outputh
				end
				
			 outputm=tostring(dmins) .. "m"
			 if dmins <10 then
				 outputm="0"..outputm
				end
				
				outputs=tostring(dseconds) .. "s"
			 if dseconds <10 then
				 outputs="0"..outputs
				end
				
				
    print (outputh..":".. outputm..":"..outputs,0,0)
				print (timeinflight,0,10)

			end
		end

  -- Game Over
  if heatbottom <=15 or ( timeinflight >1 and  rocket.y == 82) then
		 in_game = 2 -- game over
		 print ("Game Over ",90,90)
			music()
   if timeinflight > Phiscore then
			print ("Game Over ",90,90)
			print ("New High Score",80,100)
			pmem(0,timeinflight)
   else
			print ("Game Over ",90,90)
   end 
			if played_eog_sound == 0 then
 			sound(0, 14, 120, 3, 15, -4)
	   played_eog_sound = 1
			end
		end
		launchpad()
	end

end

-- end:  Skyrokit