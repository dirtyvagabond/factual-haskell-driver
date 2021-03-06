-- | This module exports the Geo type used to create read and facet queries.
module Data.Factual.Shared.Geo
  (
    -- * Geo type
    Lat
  , Long
  , Radius
  , Geo(..)
    -- * Helper functions
  , geoPair
  ) where

-- | A Lat is the latitude represented as a Double.
type Lat = Double
-- | A Long is the longitude represented as a Double.
type Long = Double
-- | A Radius is the radius of the circle as a Double in meters.
type Radius = Double

-- | The Geo type is used to limit the search to specific geograph location.
--   Currently, only circles are supported. Supply a latitude, longitude and
--   radius in meters for the circle.
data Geo = Circle Lat Long Radius
         | Point Lat Long
         deriving Eq

-- Geo is a member of Show to help generate query params.
instance Show Geo where
  show (Circle lat long radius) = "{\"$circle\":{\"$center\":[" 
                                ++ (show lat) 
                                ++ ", "
                                ++ (show long)
                                ++ "],\"$meters\":"
                                ++ (show radius)
                                ++ "}}"
  show (Point lat long) = "{\"$point\":["
                        ++ (show lat) 
                        ++ ","
                        ++ (show long)
                        ++ "]}"

-- Helper functions
geoPair :: Maybe Geo -> (String, String)
geoPair (Just g) = ("geo", show g)
geoPair Nothing  = ("geo", "")
