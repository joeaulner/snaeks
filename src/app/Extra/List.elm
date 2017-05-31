module Extra.List exposing (dropTail)


dropTail : Int -> List a -> List a
dropTail n items =
    List.take (List.length items - n) items
