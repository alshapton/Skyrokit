
print("[Opening skyrokit.tic]")

with open('../skyrokit.tic', 'rb') as f:
 s = f.read()
 print("[Extracting code]")
 start=s.find('-- title:  Skyrokit')
 end=s.find('-- end:  Skyrokit')+len('-- end:  Skyrokit')
 ss=f.read()
 ss=f.seek(start)
 filecontent=f.read(end-start)

with open('tmp.lua', 'w') as f:
 f.write(filecontent)
 f.close()

print("[Verifying status of current code]")
