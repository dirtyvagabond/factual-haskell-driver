-- | This module exports the type used to represent a table for the read or
--   schema query types.
module Data.Factual.Shared.Table
  (
     -- * Table type
     Table(..)
  ) where

-- | This type defines the available tables. Use the Custom table option for
--   tables that are not listed you.
data Table = Places
           | USRestaurants
           | Global
           | HealthCareProviders
           | WorldGeographies
           | ProductsCPG
           | ProductsCrosswalk
           | Custom String
           deriving Eq

-- Table is a member of the Show typeclass to generate the beginning of the path.
instance Show Table where
  show Places              = "/t/places/"
  show USRestaurants       = "/t/restaurants-us/"
  show Global              = "/t/global/"
  show HealthCareProviders = "/t/health-care-providers-us"
  show WorldGeographies    = "/t/world-geographies"
  show ProductsCPG         = "/t/products-cpg"
  show ProductsCrosswalk   = "/t/products-crosswalk"
  show (Custom name)       = "/t/" ++ name ++ "/"
