import depsAndMunis

deps = depsAndMunis.deps
munis = depsAndMunis.munis

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
            print(deps[dept])

            #the name of the muni 
            print(munis[str(dept)][muni])

            # num votes for first party (UNE)
            print(download_muni_data(url)['resultados'][0]['votos'])

            # percentage who voted for first party
            print(download_muni_data(url)['resultados'][0]['porcentaje'])

            # num votes for second party (FCN NATION)
            print(download_muni_data(url)['resultados'][1]['votos'])

            # percentage who voted for first party
            print(download_muni_data(url)['resultados'][1]['porcentaje'])

            print('\n')


def main():
    download_data()


if __name__ == "__main__":
    main()
