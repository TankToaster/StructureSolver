import Debug.Trace
import Data.List
import Data.Char

main :: IO ()
main = do
  putStrLn "Enter 2-letter glyphs one at a time. (lowercase is fine)"
  putStrLn "Enter anything else to finish and solve."
  glyphs <- (getUserGlyphs 0)
  putStrLn (formatOutput (solve glyphs))

getUserGlyphs :: Int -> IO [String]
getUserGlyphs count = do
  if (count /= 0) then putStrLn (show count ++ " glyphs loaded.") else return ()
  input <- getLine
  case parseGlyph input of
    Nothing -> return []
    Just aGlyph -> do
      moreGlyphs <- (getUserGlyphs (count + 1))
      return (nub (aGlyph : moreGlyphs))

parseGlyph :: String -> Maybe String
parseGlyph input
  | ((length input) /= 2) || (not (all isLetter input))
    = Nothing
  | otherwise
    = Just (map toUpper input)

solve :: [String] -> [[String]]
solve tuples
  = condenseChains (breakIntoChains [] tuples) 0

formatOutput :: [[String]] -> String
formatOutput input
  | (length input) == 1
    = intercalate "->" (head input)
  | otherwise
    = "Unable to reduce to a single chain. The partial chains are:\n" ++ (intercalate "\n" (map (intercalate "->") input))

condenseChains :: [[String]] -> Int -> [[String]]
condenseChains (chain:chains) failures
--  | trace ("chain: " ++ show chain ++ ", matches: " ++ show matches ++ ", siblings: " ++ show siblings ++ ", symmetricChains: " ++ show symmetricChains) False = undefined
  | (failures > ((length chains) + 1)) || (null chains) -- Return what we have so far if it seems we have got stuck
    = chain:chains
  | (length symmetricChains) > 0 -- Symmetric chains end and start with the same character, and so are interchangable, so just attach one and keep going
    = condenseChains ([chain ++ (head symmetricChains)] ++ (delete (head symmetricChains) chains)) 0
  | (length matches) == 1 && (length siblings) < 1 -- Extend a chain if it is a non-ambiguous match, i.e. only a single friend and no rivals
    = condenseChains ([chain ++ (head matches)] ++ (delete (head matches) chains)) 0
  | otherwise -- try the next chain in the list and increment the failure counter
    = condenseChains (chains ++ [chain]) (failures + 1)
  where
    matches = [ x | x <- chains, (head (head x)) == (last (last chain)) ] -- potential candidates to extend the current chain (friends)
    siblings = [ x | x <- chains, (last (last x)) == (last (last chain)) ] -- other chains that end with the same character as the current chain (rivals)
    symmetricChains = intersect matches siblings -- bothersome chains that start and end with the same character

breakIntoChains :: [[String]] -> [String] -> [[String]]
breakIntoChains chains glyphs
  | null glyphs
    = chains
  | otherwise
    = breakIntoChains (chains ++ [[head glyphs]]) (tail glyphs)