import Test.HUnit
import Network.Factual.API
import Data.Factual.Query
import Data.Factual.Query.ReadQuery
import Data.Factual.Query.SchemaQuery
import Data.Factual.Query.ResolveQuery
import Data.Factual.Query.GeocodeQuery
import Data.Factual.Response
import qualified Data.Map as M
import qualified Data.Factual.Write as W
import qualified Data.Factual.Query.FacetsQuery as F
import qualified Data.Factual.Query.GeopulseQuery as G
import qualified Data.Factual.Write.Submit as S
import qualified Data.Factual.Write.Flag as L

runUnitTests = runTestTT unitTests

runIntegrationTests key secret = runTestTT $ integrationTests key secret

unitTests = TestList [ TestLabel "Place table test" placeTablePathTest
                     , TestLabel "Restaurants table test" restaurantsTablePathTest
                     , TestLabel "Hotels table test" hotelsTablePathTest
                     , TestLabel "Global table test" globalTablePathTest
                     , TestLabel "Crosswalk table test" crosswalkProductsTablePathTest
                     , TestLabel "Healthcare table test" healthcareTablePathTest
                     , TestLabel "World Geographies table test" worldGeographiesTablePathTest
                     , TestLabel "CPG table test" cpgTablePathTest
                     , TestLabel "Crosswalk Products table test" crosswalkProductsTablePathTest
                     , TestLabel "Monetize table test" monetizeTablePathTest
                     , TestLabel "Custom table test" customTablePathTest
                     , TestLabel "Geopulse test" geopulsePathTest
                     , TestLabel "Geocode test" geocodePathTest
                     , TestLabel "And search test" andSearchPathTest
                     , TestLabel "Or search test" orSearchPathTest
                     , TestLabel "Select test" selectPathTest
                     , TestLabel "Limit test" limitPathTest
                     , TestLabel "Offset test" offsetPathTest
                     , TestLabel "Equal number filter test" equalNumFilterTest
                     , TestLabel "Equal string filter test" equalStrFilterTest
                     , TestLabel "Not equal number filter test" notEqualNumFilterTest
                     , TestLabel "Not equal string filter test" notEqualStrFilterTest
                     , TestLabel "In number list filter test" inNumListFilterTest
                     , TestLabel "In string list filter test" inStrListFilterTest
                     , TestLabel "Not in number list filter test" notInNumListFilterTest
                     , TestLabel "Not in string list filter test" notInStrListFilterTest
                     , TestLabel "Begins with filter test" beginsWithFilterTest
                     , TestLabel "Not begins with filter test" notBeginsWithFilterTest
                     , TestLabel "Begins with any filter test" beginsWithAnyFilterTest
                     , TestLabel "Not begins with any filter test" notBeginsWithAnyFilterTest
                     , TestLabel "Is blank filter test" isBlankFilterTest
                     , TestLabel "Is not blank filter test" isNotBlankFilterTest
                     , TestLabel "And filter test" andFilterTest
                     , TestLabel "Or filter test" orFilterTest
                     , TestLabel "Geo test" geoTest
                     , TestLabel "Include count test" includeCountTest
                     , TestLabel "Schema query test" schemaQueryTest
                     , TestLabel "Resolve query test" resolveQueryTest
                     , TestLabel "Facets test" facetsTest
                     , TestLabel "Submit path test" submitPathTest
                     , TestLabel "Submit body test" submitBodyTest
                     , TestLabel "Flag path test" flagPathTest
                     , TestLabel "Flag body test" flagBodyTest ]

integrationTests key secret = TestList [ TestLabel "Read test" (readIntegrationTest token)
                                       , TestLabel "Schema test" (schemaIntegrationTest token)
                                       , TestLabel "Resolve test" (resolveIntegrationTest token)
                                       , TestLabel "Raw read test" (rawIntegrationTest token)
                                       , TestLabel "Facets test" (facetsIntegrationTest token)
                                       , TestLabel "Geopulse test" (geopulseIntegrationTest token)
                                       , TestLabel "Geocode test" (geocodeIntegrationTest token)
                                       , TestLabel "Multi test" (multiIntegrationTest token)
                                       , TestLabel "Error test" (errorIntegrationTest token) ]
                            where token = generateToken key secret

placeTablePathTest = TestCase (do
  let expected = "/t/places?include_count=false"
  let path = formRelativePath $ blankReadQuery { table = Places }
  assertEqual "Correct path for places table" expected path)

restaurantsTablePathTest = TestCase (do
  let expected = "/t/restaurants-us?include_count=false"
  let path = formRelativePath $ blankReadQuery { table = RestaurantsUS }
  assertEqual "Correct path for us restaurants table" expected path)

hotelsTablePathTest = TestCase (do
  let expected = "/t/hotels-us?include_count=false"
  let path = formRelativePath $ blankReadQuery { table = HotelsUS }
  assertEqual "Correct path for us hotels table" expected path)

globalTablePathTest = TestCase (do
  let expected = "/t/global?include_count=false"
  let path = formRelativePath $ blankReadQuery { table = Global }
  assertEqual "Correct path for global table" expected path)

crosswalkTablePathTest = TestCase (do
  let expected = "/t/crosswalk?include_count=false"
  let path = formRelativePath $ blankReadQuery { table = Crosswalk }
  assertEqual "Correct path for crosswalk table" expected path)

healthcareTablePathTest = TestCase (do
  let expected = "/t/health-care-providers-us?include_count=false"
  let path = formRelativePath $ blankReadQuery { table = HealthCareProviders }
  assertEqual "Correct path for health care providers table" expected path)

worldGeographiesTablePathTest = TestCase (do
  let expected = "/t/world-geographies?include_count=false"
  let path = formRelativePath $ blankReadQuery { table = WorldGeographies }
  assertEqual "Correct path for world geographies table" expected path)

cpgTablePathTest = TestCase (do
  let expected = "/t/products-cpg?include_count=false"
  let path = formRelativePath $ blankReadQuery { table = ProductsCPG }
  assertEqual "Correct path for products CPG table" expected path)

crosswalkProductsTablePathTest = TestCase (do
  let expected = "/t/products-crosswalk?include_count=false"
  let path = formRelativePath $ blankReadQuery { table = ProductsCrosswalk }
  assertEqual "Correct path for products crosswalk table" expected path)

monetizeTablePathTest = TestCase (do
  let expected = "/places/monetize?include_count=false"
  let path = formRelativePath $ blankReadQuery { table = Monetize }
  assertEqual "Correct path for monetize table" expected path)

customTablePathTest = TestCase (do
  let expected = "/t/foo?include_count=false"
  let path = formRelativePath $ blankReadQuery { table = Custom "foo" }
  assertEqual "Correct path for custom table" expected path)

geopulsePathTest = TestCase (do
  let expected = "/places/geopulse?geo=%7B%22%24point%22%3A%5B34.06021%2C-118.41828%5D%7D&select=commercial_density"
  let path = formRelativePath $ G.GeopulseQuery { G.geo = Point 34.06021 (-118.41828) , G.select = ["commercial_density"] }
  assertEqual "Correct path for geopulse" expected path)

geocodePathTest = TestCase (do
  let expected = "/places/geocode?geo=%7B%22%24point%22%3A%5B34.06021%2C-118.41828%5D%7D"
  let path = formRelativePath $ GeocodeQuery $ Point 34.06021 (-118.41828)
  assertEqual "Correct path for geocode" expected path)

andSearchPathTest = TestCase (do
  let expected = "/t/places?q=foo%20bar&include_count=false"
  let path = formRelativePath $ blankReadQuery { search = AndSearch ["foo", "bar"] }
  assertEqual "Correct path for ANDed search" expected path)

orSearchPathTest = TestCase (do
  let expected = "/t/places?q=foo%2Cbar&include_count=false"
  let path = formRelativePath $ blankReadQuery { search = OrSearch ["foo", "bar"] }
  assertEqual "Correct path for ANDed search" expected path)

selectPathTest = TestCase (do
  let expected = "/t/places?select=foo%2Cbar&include_count=false"
  let path = formRelativePath $ blankReadQuery { select = ["foo", "bar"] }
  assertEqual "Correct path for select terms" expected path)

limitPathTest = TestCase (do
  let expected = "/t/places?limit=321&include_count=false"
  let path = formRelativePath $ blankReadQuery { limit = Just 321 }
  assertEqual "Correct path for limit" expected path)

offsetPathTest = TestCase (do
  let expected = "/t/places?offset=321&include_count=false"
  let path = formRelativePath $ blankReadQuery { offset = Just 321 }
  assertEqual "Correct path for offset" expected path)

equalNumFilterTest = TestCase (do
  let expected = "/t/places?filters=%7B%22field%22%3A123.4%7D&include_count=false"
  let path = formRelativePath $ blankReadQuery { filters = [EqualNum "field" 123.4] }
  assertEqual "Correct path for equal number filter" expected path)

equalStrFilterTest = TestCase (do
  let expected = "/t/places?filters=%7B%22field%22%3A%22value%22%7D&include_count=false"
  let path = formRelativePath $ blankReadQuery { filters = [EqualStr "field" "value"] }
  assertEqual "Correct path for equal string filter" expected path)

notEqualNumFilterTest = TestCase (do
  let expected = "/t/places?filters=%7B%22field%22%3A%7B%22%24neq%22%3A123.4%7D%7D&include_count=false"
  let path = formRelativePath $ blankReadQuery { filters = [NotEqualNum "field" 123.4] }
  assertEqual "Correct path for not equal number filter" expected path)

notEqualStrFilterTest = TestCase (do
  let expected = "/t/places?filters=%7B%22field%22%3A%7B%22%24neq%22%3A%22value%22%7D%7D&include_count=false"
  let path = formRelativePath $ blankReadQuery { filters = [NotEqualStr "field" "value"] }
  assertEqual "Correct path for not equal string filter" expected path)

inNumListFilterTest = TestCase (do
  let expected = "/t/places?filters=%7B%22field%22%3A%7B%22%24in%22%3A%5B123.4%2C5432.1%5D%7D%7D&include_count=false"
  let path = formRelativePath $ blankReadQuery { filters = [InNumList "field" [123.4, 5432.1]] }
  assertEqual "Correct path for in number list filter" expected path)

inStrListFilterTest = TestCase (do
  let expected = "/t/places?filters=%7B%22field%22%3A%7B%22%24in%22%3A%5B%22value%22%2C%22other%22%5D%7D%7D&include_count=false"
  let path = formRelativePath $ blankReadQuery { filters = [InStrList "field" ["value","other"]] }
  assertEqual "Correct path for in string list filter" expected path)

notInNumListFilterTest = TestCase (do
  let expected = "/t/places?filters=%7B%22field%22%3A%7B%22%24nin%22%3A%5B123.4%2C5432.1%5D%7D%7D&include_count=false"
  let path = formRelativePath $ blankReadQuery { filters = [NotInNumList "field" [123.4, 5432.1]] }
  assertEqual "Correct path for not in number list filter" expected path)

notInStrListFilterTest = TestCase (do
  let expected = "/t/places?filters=%7B%22field%22%3A%7B%22%24nin%22%3A%5B%22value%22%2C%22other%22%5D%7D%7D&include_count=false"
  let path = formRelativePath $ blankReadQuery { filters = [NotInStrList "field" ["value","other"]] }
  assertEqual "Correct path for not in string list filter" expected path)

beginsWithFilterTest = TestCase (do
  let expected = "/t/places?filters=%7B%22field%22%3A%7B%22%24bw%22%3A%22val%22%7D%7D&include_count=false"
  let path = formRelativePath $ blankReadQuery { filters = [BeginsWith "field" "val"] }
  assertEqual "Correct path for begins with filter" expected path)

notBeginsWithFilterTest = TestCase (do
  let expected = "/t/places?filters=%7B%22field%22%3A%7B%22%24nbw%22%3A%22val%22%7D%7D&include_count=false"
  let path = formRelativePath $ blankReadQuery { filters = [NotBeginsWith "field" "val"] }
  assertEqual "Correct path for not begins with filter" expected path)

beginsWithAnyFilterTest = TestCase (do
  let expected = "/t/places?filters=%7B%22field%22%3A%7B%22%24bwin%22%3A%5B%22val%22%2C%22ot%22%5D%7D%7D&include_count=false"
  let path = formRelativePath $ blankReadQuery { filters = [BeginsWithAny "field" ["val","ot"]] }
  assertEqual "Correct path for begins with any filter" expected path)

notBeginsWithAnyFilterTest = TestCase (do
  let expected = "/t/places?filters=%7B%22field%22%3A%7B%22%24nbwin%22%3A%5B%22val%22%2C%22ot%22%5D%7D%7D&include_count=false"
  let path = formRelativePath $ blankReadQuery { filters = [NotBeginsWithAny "field" ["val","ot"]] }
  assertEqual "Correct path for not begins with any filter" expected path)

isBlankFilterTest = TestCase (do
  let expected = "/t/places?filters=%7B%22field%22%3A%7B%22%24blank%22%3Atrue%7D%7D&include_count=false"
  let path = formRelativePath $ blankReadQuery { filters = [IsBlank "field"] }
  assertEqual "Correct path for is blank filter" expected path)

isNotBlankFilterTest = TestCase (do
  let expected = "/t/places?filters=%7B%22field%22%3A%7B%22%24blank%22%3Afalse%7D%7D&include_count=false"
  let path = formRelativePath $ blankReadQuery { filters = [IsNotBlank "field"] }
  assertEqual "Correct path for is not blank filter" expected path)

andFilterTest = TestCase (do
  let expected = "/t/places?filters=%7B%22%24and%22%3A%5B%7B%22field1%22%3A%7B%22%24blank%22%3Atrue%7D%7D%2C%7B%22field2%22%3A%7B%22%24blank%22%3Afalse%7D%7D%5D%7D&include_count=false"
  let path = formRelativePath $ blankReadQuery { filters = [And [IsBlank "field1", IsNotBlank "field2"]] }
  assertEqual "Correct path for and filter" expected path)

orFilterTest = TestCase (do
  let expected = "/t/places?filters=%7B%22%24or%22%3A%5B%7B%22field1%22%3A%7B%22%24blank%22%3Atrue%7D%7D%2C%7B%22field2%22%3A%7B%22%24blank%22%3Afalse%7D%7D%5D%7D&include_count=false"
  let path = formRelativePath $ blankReadQuery { filters = [Or [IsBlank "field1", IsNotBlank "field2"]] }
  assertEqual "Correct path for or filter" expected path)

geoTest = TestCase (do
  let expected = "/t/places?geo=%7B%22%24circle%22%3A%7B%22%24center%22%3A%5B300.1%2C%20200.3%5D%2C%22%24meters%22%3A100.5%7D%7D&include_count=false"
  let path = formRelativePath $ blankReadQuery { geo = Just (Circle 300.1 200.3 100.5) }
  assertEqual "Correct path for geo" expected path)

includeCountTest = TestCase (do
  let expected = "/t/places?include_count=true"
  let path = formRelativePath $ blankReadQuery { includeCount = True }
  assertEqual "Correct path for include count" expected path)

schemaQueryTest = TestCase (do
  let expected = "/t/places/schema"
  let path = formRelativePath $ SchemaQuery Places
  assertEqual "Correct path for a schema query" expected path)

resolveQueryTest = TestCase (do
  let expected = "/places/resolve?values=%7B%22field1%22%3A%22value1%22%2C%22field2%22%3A32.1%7D"
  let path = formRelativePath $ ResolveQuery [ResolveStr "field1" "value1", ResolveNum "field2" 32.1]
  assertEqual "Correct path for a resolve query" expected path)

facetsTest = TestCase (do
  let expected = "/t/places/facets?q=starbucks&select=locality%2Cregion&filters=%7B%22country%22%3A%22US%22%7D&limit=10&min_count=2&include_count=false"
  let path = formRelativePath $ F.FacetsQuery { F.table        = Places
                                    , F.search       = AndSearch ["starbucks"]
                                    , F.select       = ["locality", "region"]
                                    , F.filters      = [EqualStr "country" "US"]
                                    , F.geo          = Nothing
                                    , F.limit        = Just 10
                                    , F.minCount     = Just 2
                                    , F.includeCount = False }
  assertEqual "Correct path for a facets query" expected path)

submitPathTest = TestCase (do
  let expected = "/t/places/foobar/submit"
  let path = W.path submitWrite
  assertEqual "Correct path for submit" expected path)

submitBodyTest = TestCase (do
  let expected = "user=user123&values={\"key\":\"val\"}"
  let body = W.body submitWrite
  assertEqual "Correct body for submit" expected body)

flagPathTest = TestCase (do
  let expected = "/t/places/foobar/flag"
  let path = W.path flagWrite
  assertEqual "Correct path for flag" expected path)

flagBodyTest = TestCase (do
  let expected = "problem=Duplicate&user=user123&comment=There was a problem&debug=false"
  let body = W.body flagWrite
  assertEqual "Correct body for flag" expected body)

readIntegrationTest :: Token -> Test
readIntegrationTest token = TestCase (do
  let query = ReadQuery { table = Places
                        , search = AndSearch ["McDonalds", "Burger King"]
                        , select = ["name"]
                        , limit = Just 50
                        , offset = Just 10
                        , includeCount = True
                        , geo = Just (Circle 34.06021 (-118.41828) 5000.0)
                        , filters = [EqualStr "name" "Stand"] }
  result <- makeRequest token query
  assertEqual "Valid read query" "ok" (status result))

schemaIntegrationTest :: Token -> Test
schemaIntegrationTest token = TestCase (do
  let query = SchemaQuery Places
  result <- makeRequest token query
  assertEqual "Valid schema query" "ok" (status result))

resolveIntegrationTest :: Token -> Test
resolveIntegrationTest token = TestCase (do
  let query = ResolveQuery [ResolveStr "name" "McDonalds"]
  result <- makeRequest token query
  assertEqual "Valid resolve query" "ok" (status result))

rawIntegrationTest :: Token -> Test
rawIntegrationTest token = TestCase (do
  result <- makeRawRequest' token "/t/places?q=starbucks"
  assertEqual "Valid read query" "ok" (status result))

facetsIntegrationTest token = TestCase (do
  let query = F.FacetsQuery { F.table        = Places
                            , F.search       = AndSearch ["Starbucks"]
                            , F.select       = ["country"]
                            , F.filters      = []
                            , F.geo          = Nothing
                            , F.limit        = Just 100
                            , F.minCount     = Just 1
                            , F.includeCount = False }
  result <- makeRequest token query
  assertEqual "Valid facets query" "ok" (status result))

geopulseIntegrationTest token = TestCase (do
  let query = G.GeopulseQuery { G.geo    = Point 34.06021 (-118.41828)
                              , G.select = [] }
  result <- makeRequest token query
  assertEqual "Valid geopulse query" "ok" (status result))

geocodeIntegrationTest token = TestCase (do
  let query = GeocodeQuery $ Point 34.06021 (-118.41828)
  result <- makeRequest token query
  assertEqual "Valid geopulse query" "ok" (status result))


multiIntegrationTest :: Token -> Test
multiIntegrationTest token = TestCase (do
  let query1 = ReadQuery { table = Places
                         , search = AndSearch ["McDonalds", "Burger King"]
                         , select = ["name"]
                         , limit = Just 50
                         , offset = Just 10
                         , includeCount = True
                         , geo = Just (Circle 34.06021 (-118.41828) 5000.0)
                         , filters = [EqualStr "name" "Stand"] }
  let query2 = query1 { filters = [EqualStr "name" "Xerox"] }
  results <- makeMultiRequest token $ M.fromList [("query1", query1), ("query2", query2)]
  let result1 = results M.! "query1"
  let result2 = results M.! "query2"
  assertEqual "Valid multi query" ["ok","ok"] [status result1, status result2])

errorIntegrationTest :: Token -> Test
errorIntegrationTest token = TestCase (do
  result <- makeRawRequest' token "/t/foobarbaz"
  assertEqual "Invalud read query" "error" (status result))

blankReadQuery :: ReadQuery
blankReadQuery = ReadQuery { table = Places
                           , search = AndSearch []
                           , select = []
                           , limit = Nothing
                           , offset = Nothing
                           , filters = []
                           , geo = Nothing
                           , includeCount = False }

submitWrite :: S.Submit
submitWrite = S.Submit { S.table     = Places
                       , S.user      = "user123"
                       , S.factualId = Just "foobar"
                       , S.values    = M.fromList [("key", "val")] }

flagWrite :: L.Flag
flagWrite = L.Flag { L.table     = Places
                   , L.factualId = "foobar"
                   , L.problem   = L.Duplicate
                   , L.user      = "user123"
                   , L.comment   = Just "There was a problem"
                   , L.debug     = False
                   , L.reference = Nothing }
