// Необходимо реализовать систему управления тегами у статей.
// Дан дата класс, состоящий из - названия статьи, аннотации (1-2 предложения) и списка тегов (set)
// 1. Добавление нового тега в статью
// 2. Автоматическое добавление тега ко всем статьям, где в аннотации присутствует вводимое слово
// 3. Вывод всех названий статей, где присутствует введённый тег

data class Article(
    val name: String,
    val annotation: String,
    val tags: MutableSet<String>
)

fun main() {
    val articles = mutableListOf(
        Article("Kotlin Basics", "Introduction to Kotlin and collections", mutableSetOf("kotlin", "basics")),
        Article("Advanced Kotlin", "Covers topics like coroutines and generics", mutableSetOf("kotlin", "advanced")),
        Article("Python Guide", "A beginner's guide to Python programming", mutableSetOf("python", "guide"))
    )

    fun addTag(articleName: String, newTag: String) {
        val found = articles.find { it.name == articleName }
        if (found != null) {
            found.tags.add(newTag.lowercase())
            println("Тег '$newTag' добавлен в статью '${found.name}'")
        } else {
            println("Статья '$articleName' не найдена")
        }
    }

    fun addTagByAnnotation(keyword: String, newTag: String) {
        val lowerKeyword = keyword.lowercase()
        var count = 0
        for (article in articles) {
            if (article.annotation.lowercase().contains(lowerKeyword)) {
                article.tags.add(newTag.lowercase())
                count++
            }
        }
        println("Тег '$newTag' добавлен к $count статьям, где в аннотации найдено слово '$keyword'")
    }

    fun findArticlesByTag(tag: String) {
        val lowerTag = tag.lowercase()
        val found = articles.filter { lowerTag in it.tags }
        if (found.isEmpty()) {
            println("Нет статей с тегом '$tag'")
        } else {
            println("Статьи с тегом '$tag':")
            found.forEach { println("- ${it.name}") }
        }
    }

    addTag("Kotlin Basics", "education")
    addTagByAnnotation("guide", "learning")
    findArticlesByTag("learning")
}
