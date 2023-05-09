import re

persons = {}
couples = []


with open("family.ged", 'r') as file:
     ID = None
     Name = None
     HUSB = None
     WIFE = None

     for line in file:
        #поиск людей
        id = re.search(r"^0\s+@I(\d+)@\s+INDI$", line)
        name = re.search(r"^1\s+NAME\s+(.+)\s+/(.+)/$", line)
        if(id is not None):
            ID = id.group(1)
        if (ID is not None and (line.find('NAME',0,len(line)-1)!=-1)):
            word = line.replace("\n", "").split(' ')
            for x in word: 
                if not x.find("/"):
                    word.remove(x)
            Name = " ".join(word[2:])
        if(Name and ID is not None):
            persons[ID] = Name
            Name, ID = None, None
           

        #поиск родителей
        husb = re.search(r"^1\s+HUSB\s+@I(\d+)@$", line)
        wife = re.search(r"^1\s+WIFE\s+@I(\d+)@$", line)
        if(husb is not None):
            WIFE = None
            HUSB = husb.group(1)
        if(wife is not None):
            WIFE = wife.group(1)
        if(WIFE and HUSB is not None):
            chill = re.search(r"^1\s+CHIL\s+@I(\d+)@$", line)
            if(chill is not None):
                couples.append([chill.group(1), HUSB, WIFE])

with open("family.pl", 'w') as file:
    for x in couples:
        file.write("parents('" + persons[x[0]] + "','" + persons[x[1]] + "','" + persons[x[2]] + "').\n")
        
