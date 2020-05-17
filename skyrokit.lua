-- title:  Skyrokit
-- author: Andrew Shapton
-- desc:   Fly your missions!
-- script: lua
-- saveid: Skyrokit-SAVE 

-- Version: 0.2
-- ================================== --
-- S T A R T   O F  F U N C T I O N S --
-- ================================== --

function position_landinggear()
 bx = rocket.x+10
	by = rocket.y+40

 -- left landing gear
 f={x=bx,y=by}
 t={x=bx+30,y=by}
 f2={x=bx,y=by}
 t2={x=bx+10,y=by}

 -- right landing gear
 fr={x=f.x+rw,y=by}
 tr={x=t.x+rw,y=by}
 fr2={x=f2.x+rw,y=by}
 tr2={x=t2.x+rw,y=by}
end 

function setup_landinggear()
show_landing_gear = false
--rocket width
rw=10
-- landing gear core angles
angl = 270
angr = 90

-- landinggear intermediate store
p={x=0,y=0}
end

function r(f,a,t)
-- calculate end points of line given angle
local c,an,s
an=a*(3.141/180)
c=math.cos(an)
s=math.sin(an)
p.x=((c*(t.x-f.x))-(s*(t.y-f.y))+f.x)
p.y=((s*(t.x-f.x))+(c*(t.y-f.y))+f.y)
return p
end

function gear(f,t,angl,fr,tr,angr)
local p
p=r(f,angl,t)
line(f.x,f.y,p.x,p.y,15)
line(f.x-1,f.y,p.x-1,p.y,15)
line(f2.x,f2.y-10,p.x,p.y,15)
p=r(f2,angl,t2)
line(f2.x,f2.y-10,p.x,p.y,15)
angr=angr+180
p=r(fr,angr,tr)
line(fr.x,fr.y-10,p.x,p.y,15)
line(fr.x-1,fr.y,p.x-1,p.y,15)
line(fr2.x,fr2.y,p.x,p.y,15)
p=r(fr2,angr,tr2)
line(fr2.x,fr2.y-10,p.x,p.y,15)
end

function landinggear()
if show_landing_gear == true then
position_landinggear()
if angl >135 then
angl=angl-0.5
end
if angr <225 then
angr=angr+0.5
end
gear(f,t,angl,fr,tr,angr)
end

end


function startup()
 hsteer       = 0.5 --- horizontal steering factor
 TICS_IN_SEC  = 60
 crawlstay    = 0
 crawlstaytime= TICS_IN_SEC * 10 -- 10 seconds
 docrawl      = 1
 crawlspace   = 0.15
 finishcrawl  = (crawlspace * 1000) * 2.3
 interval     = 10
 topcrawl     = 128
 in_space     = 500
 comet        = false
 sound_on     = 0
 music_on     = 0
 version      = "0.2"
 starlimit    = 1
 seconds      = 0
 mins         = 0
 hours        = 0
 dseconds     = 0
 dmins        = 0
 dhours       = 0
 timeinflight = 0
 score        = 0
 score_increment = 1
		
 Phiscore = pmem(0) -- persistent memory hiscore
 Psound   = pmem(1) -- persistent memory score
 Pmusic   = pmem(2) -- persistent memory music
  
	payload      = {x=-1,y=-1}
 show_payload = false 
 heatframe    = 0
 orange       = 9
 red          = 6
 heatcolour   = orange
 fuel         = 130 -- how much fuel we start  with
 

 st        = 0
 tx        = 240
 stars     = {}      -- stars array
 fill_stars()        -- populate stars array

 in_game   = -1      -- not started game yet
 -- Initialise comet arrays
 cometheight1 = {x = 0,y = 0} 
 cometheight2 = {x = 0,y = 0} 
	
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
 
 -- set up the landing gear constants
 setup_landinggear()

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

function displaycrawl()
 -- Crawler instructions and backstory
 print("NOT  LONG  AGO IN A",5,topcrawl-6,15,true,2,false)
 print("PLACE KNOWN TO MOST",5,topcrawl+interval,15,true,2,false)
 print("It is a period of intense competition.",5,topcrawl+(interval * 4),15,true,1,false)
 print("Many  tests  of  different  ships have",5,topcrawl+(interval * 5),15,true,1,false)
 print("been done in  hidden  proving grounds.",5,topcrawl+(interval * 6),15,true,1,false)
 print("The  first  steps  against  government",5,topcrawl+(interval * 7),15,true,1,false)
 print("controlled  space flight  have  begun.",5,topcrawl+(interval * 8),15,true,1,false)
 print("During  the  tests, one  mighty  space",5,topcrawl+(interval * 10),15,true,1,false)
 print("vehicle  towers  way above  the  rest.",5,topcrawl+(interval * 11),15,true,1,false)
 print("SKY ROKIT,  a lean,  sleek,  beautiful",5,topcrawl+(interval * 12),15,true,1,false)
 print("piece of engineering, carrying  enough",5,topcrawl+(interval * 13),15,true,1,false)
 print("power to  beat the  others to the sky.",5,topcrawl+(interval * 14),15,true,1,false)
 print("Watched by the government, there is  a",5,topcrawl+(interval * 16),15,true,1,false)
 print("rush to get the  craft into the depths",5,topcrawl+(interval * 17),15,true,1,false)
 print("of  space  in order to  show that  the",5,topcrawl+(interval * 18),15,true,1,false)
 print("minnows  can  outsmart the  sharks and",5,topcrawl+(interval * 19),15,true,1,false)
 print("gain freedom for the  skies  . . . . .",5,topcrawl+(interval * 20),15,true,1,false)
 display_help(40,topcrawl+(interval * 23))
	if 128-topcrawl <= finishcrawl then
	 topcrawl = topcrawl - crawlspace
	end
end

function display_help(mx,my)
 -- show help screen and controls
 map (0,0,10,5,mx,my,14,2)

 print("<space> or   to start",20,my+(interval*8)+2,15,true,1,true)
	spr(191,mx+22,my+(interval * 8)+1,10,1) 
 print(" <UP> or   to thrust",138,topcrawl+(interval * 31)+2,15,true,1,true)
	spr(111,mx+131,my+(interval * 8)+1,10,1) 

 print("<Q> or   for payload",22,topcrawl+(interval * 32)+1,15,true,1,true)
	spr(175,mx+8,my+(interval * 9),10,1) 
 print("<DOWN> or   for landing gear",124,topcrawl+(interval * 32)+1,15,true,1,true)
	spr(191,mx+121,my+(interval * 9),10,1) 

 print("<LEFT> & <RIGHT> or   &   to steer",55,topcrawl+(interval * 33)+1,15,true,1,true)
	spr(207,mx+92,my+(interval * 10),10,1) 
 spr(223,mx+108,my+(interval * 10),10,1) 
 print("<DOWN> or   for landing gear",124,topcrawl+(interval * 32)+1,15,true,1,true)
	spr(191,mx+121,my+(interval * 9),10,1) 

end

-- Start Screen
function startscreen()
 -- should show crawler ?
 docrawl=docrawl+1
 if docrawl >= TICS_IN_SEC * 10 then
 	displaycrawl()
 else
 -- Display Start  Screen
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
  -- patch tiles
  spr(106,0,40,0,1,0,0,1,7)
  spr(106,8,40,0,1,0,0,1,6)

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
	
	
  print ("     High Score: "..tostring(Phiscore),80,60)
  print("<space> or    to start",82,70)
  print(" <UP> or    to thrust",82,80)
	 spr(111,125,79,10,1) 
	 spr(191,140,69,10,1) 
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

 end
 -- start  game ?
 if keyp(48,1,1) or btnp(1,0,0) then
  in_game=0
  if music_on == 1 then
   music(0,0,0,true)
  end
 end 
end

function display_starfield()
-- increment starfield as the game moves on
 if in_game <2 then
  starlimit = timeinflight / 100
  if starlimit >99 then
   starlimit = 99
  end
  if timeinflight > in_space then
   dstars(starlimit,-1) -- remember to change colours here.
  end
 end
end

function x2x(x,y,angle)
 return (x * math.cos(angle)) - (y * math.sin(angle))
end
function y2y(x,y,angle)
 return (x * math.cos(angle)) - (y * math.sin(angle))
end

function display_rocket()
-- display the rocket in flight

-- change flame sprite if required
 if show_payload == true then
	 inc=16
	else
	 inc=0
	end
	if c == 5 then
  if rocket.t == 262+inc then
   rocket.t=266+inc
  else
   rocket.t=262+inc
  end
  -- reset ticker to zero
  c = 0
 end
 if show_payload==false then  
  spr(rocket.t,rocket.x,rocket.y-1,0,1,0,0,4,10)
 else
  spr(rocket.t,rocket.x,rocket.y-1+8,0,1,0,0,4,10)
 end	

	if show_pad == 1 then
  spr(271,rocket.x,rocket.y+31,0,1,0,0,1,3)
  spr(271,rocket.x+23,rocket.y+31,0,1,1,0,1,3)
 else
  spr(319,rocket.x,rocket.y+31,-1,1,0,0,1,3)
  spr(319,rocket.x+23,rocket.y+31,-1,1,1,0,1,3)
	 --detach fins ?
  if rocket.hasfins == 1 then
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
end

function display_gauge()
 -- set colour of heat
 if heatbottom <=26 then
  heatcolour=red
 else
  heatcolour=orange
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

end


function steer()
 -- check for steering
	if btnp(2,1,1)   then
	-- steer left
	if rocket.x > 2 then
	  rocket.x=rocket.x - hsteer
 end 
	end
	if btnp(3,1,1)   then
	-- steer right
	if rocket.x <190  then
	  rocket.x=rocket.x + hsteer
 end 
	end

end
function display_score()
 -- Score
 if rocket.inflight == 1 then
  if in_game ~= 2 then
   outputs=""
   if dseconds <10 then
    outputs="0"..outputs
   end
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
    timeinflight = timeinflight+1
    score = score + score_increment
    seconds = seconds + 1
   end			
			
   outputh=tostring(dhours) .. "h"
   if dhours <10 then
    outputh="0"..outputh
   end
   outputm=tostring(dmins) .. "m"
   if dmins <10 then
    outputm="0"..outputm
   end

   outputs=tostring(dseconds) .. "s"
   print (outputh..":".. outputm..":"..outputs,0,0)
   print ("Score:"..score,0,10)
  end
 end
end

function is_game_over()
 -- check to see if the game is over
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
end

function manage_heat()
 if heatframe >= 60 then
  if btnp(0,1,1) or btnp(4,1,1) then
   heatbottom=heatbottom-heatuse
  else
   if heatbottom <= 137 then
    heatbottom=heatbottom+heatuse
   end
  end
  heatframe = 0
  heattick  = 0
 end			
end

function reduce_fuel()
-- If fuel needs reducing then do so
 if fueltick >= 100 then
  fuel     = fuel    - fueluse
  fueltop  = fueltop + fueluse
  fueltick = 0
 end
end

function manage_gauges()
 -- reduce fuel if required
 reduce_fuel()		
		
 -- manage heat
 manage_heat()
end

function angleBetweenPoints(a, b)
 deltaY = math.abs(b.y - a.y)
 deltaX = math.abs(b.x - a.x)
 return math.deg(math.atan2(deltaY,deltaX))
end

function distance(p, q)
 dx   = p.x - q.x         
 dy   = p.y - q.y         
 dist = math.sqrt( dx*dx + dy*dy ) 
 return dist
end

-- ================================== --
--    M A J O R   F U N C T I O N S   --
-- ================================== --

function display()
 -- Display (z-order - reverse to front)
	
 -- starfield
 display_starfield()

 -- rocket
 display_rocket()

 -- gauge
 display_gauge()
		  
 --	score
 display_score()

 -- Game Over ?
 is_game_over()
		
 -- show launchpad ?
 launchpad()
end

function display_payload()
 --pop payload  behind rocket
 if show_payload == true then
	 spr(260,payload.x+8,payload.y-1,14,1,0,0,2,2)
  payload.y=payload.y-0.1
 end
end


-- ================================== --
--    E N D  O F  F U N C T I O N S   --
-- ================================== --

-- Startup
startup()


-- Background gradient
function SCN(line)
 if timeinflight < in_space then
		poke(0x3fc2,line)
	end
 if timeinflight > in_space then
		poke(0x3fc1,line)
	end
 if timeinflight > (in_space*2) then
		poke(0x3fc0,line)
			
 end 
	
end

-- Foreground graphics
function OVR()
if in_game == 1 then
if timeinflight > in_space then
--comet
if comet == false then
	cometyes = math.random(0,10)
	if cometyes < 4 then
 -- 	create comet
	 comet = true
	 rside = math.random(0,1)
  if rside < 0.5 then
			 cometheight1.y = math.random(0,64)
	 cometheight1.x = 0
  cometheight2.x = 220
	 cometheight2.y = 64 + math.random(0,64)
  else
	 cometheight1.y = math.random(0,64)
	 cometheight1.x = 220
  cometheight2.x = 0
	 cometheight2.y = 64 + math.random(0,64)
  end
		cx= cometheight1.x
	 cy=	cometheight1.y
	 angle = angleBetweenPoints(cometheight1, cometheight2)
  dist  = distance(cometheight1, cometheight2)
  speed_in_tics=30 * math.random(1,10)  -- 2 seconds
  dx=(cometheight1.x-cometheight2.x)
  dy=(cometheight1.y-cometheight2.y)
	 vecx=dx/speed_in_tics
	 vecy=dy/speed_in_tics 
 end
	else
	 cx=cx-vecx
	 cy=cy-vecy
		-- ensure comets are not drawn over the gauges
		clip(0,0,219,128)
	 circ(cx,cy,5,15)
  clip()
		if cx > 240 or cx < 0 then
		comet = false
		end
end
end
end
end


--- Main Loop (frame)
function TIC()
	-- clear display before frame
 cls(0)
	
 -- manage crawler time
	if ((128-topcrawl) >= finishcrawl) and (in_game == -1) then		
	 crawlstay = crawlstay + 1
 end
	
	if crawlstay >= crawlstaytime  then
	 crawlstay = 1
		docrawl   = 0
		topcrawl  = 128
	end

 -- check game state machine
 if in_game == -1 then
  startscreen() 
	else
	 if in_game == 1 then
		 -- check for payload release
			if keyp(17,0,0) then
			 if payload.x < 0 then
			  show_payload=true
					payload.x = rocket.x
				 payload.y = rocket.y
				end 
			end
			-- check for landing gear release
			if show_payload == true then
    if show_landing_gear == false then
     if rocket.hasfins == 0 then
			   if btnp(1,0,0) then
			     show_landing_gear=true
			    end		
			   end
				end 
			end
		end 
  if in_game <2 then	
 		heatframe = heatframe+1
			-- any steering required
			steer()	
  	if btnp(0,1,1) or btnp(4,1,1)  then
		  if in_game == 0 then
		   seconds = 0
    end
   in_game          = 1 -- game is on
   rocket.inflight  = 1
   heattick = heattick+1	-- update heat ticker because fuel is being used
   fueltick = fueltick+1	-- update fuel ticker because fuel is being used
   
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
		 manage_gauges()	
	
 end
	 -- show display
  display()
		display_payload()
  landinggear()	
	end
 
end

-- end:  Skyrokit