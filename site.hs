--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Data.Monoid (mappend)
import           Hakyll

--------------------------------------------------------------------------------
main :: IO ()
main = hakyll $ do
    match "static/*" $ do
        route $ gsubRoute "static/" (const "")
        compile copyFileCompiler

    match "posts/*" $ do
        route $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/post.html"    postCtx
            >>= loadAndApplyTemplate "templates/default.html" postCtx
            >>= relativizeUrls

    match "index.markdown" $ do
        route $ setExtension "html"
        compile $ do
            posts <- recentFirst =<< loadAll "posts/*"
            let indexCtx =
                    listField "posts" postCtx (return posts) `mappend`
                    defaultContext

            getResourceBody
                >>= applyAsTemplate indexCtx
                >>= renderPandoc
                >>= loadAndApplyTemplate "templates/default.html" indexCtx
                >>= relativizeUrls
                >>= withItemBody (unixFilter "minify" ["--type", "html"])

    match "templates/*" $ compile templateBodyCompiler

    match "css/default.sass" $ do
        route   $ setExtension "css"
        compile $ getResourceString
            >>= withItemBody (unixFilter "sass" ["--no-source-map", "css/default.sass"])
            >>= return . fmap compressCss

--------------------------------------------------------------------------------
postCtx :: Context String
postCtx =
    dateField "date" "%B %Y" `mappend`
    defaultContext
