import depsAndMunis

deps = depsAndMunis.deps
munis = depsAndMunis.munis

f = open('elecData2015.csv','a')
f.write("DEPT,MUNI,UNE_NUM_VOTES,PERC_UNE,FCN_NUM_VOTES,PERC_FCN\n") 


def download_muni_data(api_url):
    import requests
    data = requests.post(api_url)
    return data.json()


def get_data_for_muni(dept, muni):
    api_url = 'http://resultados2015.tse.org.gt/2v/resultados-2015/data.php?departamento={}&municipio={}&te=1&titulo=heyheyhey'.format(dept, muni)
    print("Getting data for dept {} and muni {}".format(
        deps[dept], munis[str(dept)][muni]))
    return api_url


def download_data():
    for dept in deps:
        for muni in munis[str(dept)]:
            url = get_data_for_muni(dept, muni)
            
            #print(download_muni_data(url)['resultados'])

            #print(download_muni_data(url))

            # Write/append all of the following to a csv:
            # DEPT,MUNI,UNE_NUM_VOTES,PERC_UNE,FCN_NUM_VOTES,PER_FCN

            # the name of the dept
            dep = (deps[dept])

            #the name of the muni 
            mun = (munis[str(dept)][muni])

            # num votes for first party (UNE)
            numVotesUNE = (download_muni_data(url)['resultados'][0]['votos'])

            # percentage who voted for first party
            percVotesUNE = (download_muni_data(url)['resultados'][0]['porcentaje'])

            # num votes for second party (FCN NATION)
            numVotesFCN = (download_muni_data(url)['resultados'][1]['votos'])
        

            # percentage who voted for first party
            percVotesFCN = (download_muni_data(url)['resultados'][1]['porcentaje'])

            line = dep + "," + mun + "," + numVotesUNE + "," + percVotesUNE + "," + numVotesFCN + "," + percVotesFCN + "\n"

            f.write(line)





def main():
    download_data()
    f.close()


if __name__ == "__main__":
    main()
