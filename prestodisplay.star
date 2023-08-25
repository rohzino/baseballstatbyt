load("render.star", "render")
load("xpath.star", "xpath")
load("http.star", "http")

statFeed = "http://stats.traetoelle.com/baseball/livestats.xml"

def main():
    Vname, Vruns, Vhits, Verrs = getVStats()
    Hname, Hruns, Hhits, Herrs = getHStats()

    VnameShort = Vname[:4]
    HnameShort = Hname[:4]
    
    return render.Root(
        child = render.Row( # main display row, everything is nested in here
            main_align="space_between",
            children=[
                render.Column( # column to display score
                    main_align="start",
                    cross_align="start",
                    expanded=True,
                    children=[
                        render.Box(
                            width=32,
                            height=16,
                            color="#0f1117",
                            child=render.Text(content=VnameShort + " " + Vruns, font="tb-8"),
                        ),
                        render.Box(
                            width=32,
                            height=16,
                            color="#461d7c",
                            child=render.Text(content=HnameShort + " " + Hruns, font="tb-8"),
                        ),

                    ],

                ),
                render.Column(# column to display hits and errors identifiers
                    main_align="space_between",
                    cross_align="center",
                    children=[
                        render.Row(
                            children=[
                                render.Text(content="  H   E"),

                            ],

                        ),

                        render.Padding( # line
                            pad = (4, 0, 0, 0),
                            child=render.Box(height=1, width=21, color="FFF"),
                        ),

                        render.Row( # row that displays visitng hits + errors
                            children=[
                                render.Padding(
                                    pad = (3, 0, 0, 0),
                                    child=render.Text(content=Vhits + "  " + Verrs),

                                ),

                            ],

                        ),
                        render.Row( # row that displays home hits + errors
                            children=[
                                render.Padding(
                                    pad = (3, 0, 0, 0),
                                    child=render.Text(content=Hhits + "  " + Herrs),

                                ),

                            ],

                        ),

                    ],

                        ),

                    ],
                ),

        )
      
def getVStats():
    resp = http.get(statFeed)
    if resp.status_code == 200: # status code to make sure we're getting a result | XPath query to pull multiple attributes from the visiting team
        results = xpath.loads(resp.body()).query_all("//team[@vh='V']//@id | //bsgame//team[@vh='V']//linescore/@runs | //bsgame//team[@vh='V']//linescore/@hits | //bsgame//team[@vh='V']//linescore/@errs")
        if len(results) > 0:
            
            Vname = results[0]
            Vruns = results[1]
            Vhits = results[2]
            Verrs = results[3]

            # Return the variables for further use in the program
            return Vname, Vruns, Vhits, Verrs
        return "ERR"

def getHStats():
    resp = http.get(statFeed)
    if resp.status_code == 200: # status code to make sure we're getting a result | XPath query to pull multiple attributes from the visiting team
        results = xpath.loads(resp.body()).query_all("//team[@vh='H']//@id | //bsgame//team[@vh='H']//linescore/@runs | //bsgame//team[@vh='H']//linescore/@hits | //bsgame//team[@vh='H']//linescore/@errs")
        if len(results) > 0:
            
            Hname = results[0]
            Hruns = results[1]
            Hhits = results[2]
            Herrs = results[3]

            # Return the variables for further use in the program
            return Hname, Hruns, Hhits, Herrs
        return "ERR"
		
