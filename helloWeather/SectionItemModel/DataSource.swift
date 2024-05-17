import Foundation

enum SearchViewSection : String{
    case recentSearch = "최근 검색 기록"
    case relatedSearch = "연관 검색"
}

enum SearchViewSectionItem : Hashable{
    case recentSearch(SearchModel)
    case relatedSearch(SearchModel)
}

enum ListViewSection {
    case currentWeather
    case space
    case listWeather
}

enum ListViewSectionItem : Hashable {
    case currentWeather(SearchModel)
    case space
    case listWeather(SearchModel)
}
