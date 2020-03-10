from random import randint, shuffle

sizeX = 20
sizeY = 20

maxHumansN = sizeX*sizeY // 2
maxOrcsN = sizeX*sizeY // 2

humansN = randint(0, min(sizeX*sizeY - 2, maxHumansN))
orcsN = randint(0, min(sizeX*sizeY - 2 - humansN, maxOrcsN))

print(humansN, orcsN)

places = [(x, y) for x in range(0, sizeX) for y in range(0, sizeY) if not (x == 0 and y == 0)]
shuffle(places)

humans = [places.pop() for _ in range(humansN)]
orcs = [places.pop() for _ in range(orcsN)]

touchDown = places.pop()

text = "".join(f"h{h}.\n" for h in humans)
text += "h(-1,-1).\n"
text += "".join(f"o{o}.\n" for o in orcs)
text += "o(-1,-1).\n"
text += f"t{touchDown}.\n"
text += "start_pos(0,0).\n"
text += "max_attempts(100).\n"
text += f"size{(sizeX, sizeY)}.\n"

with open("input.pl", "w") as f:
    f.write(text)
