---
date: '2025-07-13T19:51:31+05:30'
draft: false
title: 'Fundamentals of Regular Expressions'
tags:
- linux
- permissions
- ownerships

cover:
    image: posts/regex/img/regex-black.png
    alt: regular expression

params:
    author: "Yashwanth Rathakrishnan"
    ShowCodeCopyButtons: true
    ShowReadingTime: true
    ShowToc: true
    TocOpen: true
---

# Regular Expression
Regular expression is a _method of pattern matching_. It **allows you to define patterns of texts and search for it in other texts**, no matter the complexity or the amount of text there is to process.

Using regular expression is considered a _more efficient solution, when there's complexity in searching for a text_ that you want to find. It is also called as **regex**.

> Keep in mind that regular expression is supported in almost every programming language. If you were to face a situation when there's complexity in searching a text, take a look at how the systax looks like other programming languages and utilize them.

## Getting Started with Regular Expressions
Learning the fundamentals before diving into the advanced areas will help you grasp the concept. 

### 1. Literal Strings
This is a simple and a straightforward matching, that it simply matches _"hello"_ with _"hello"_. This is yet another way to using regex, but a simple search as well.

### 2. Metacharacters
It uses special characters(**symbols other than alpha-numeric**) and each gives a special meaning in regular expression.

- `.` = Dot
    - Match any single character; It **must include any single** character.
    - `h-y` = `hey` or `hoy` or `huy`...

- `^` = Caret
    - Aka **Anchor**. It matches any string that **starts with** `^`.
    - Eg: `^abc` - It looks for string that starts with `abc`.

- `$` = Dollar Sign
    - It matches any string that **ends with** `$`.
    - Eg: `abc$` - It looks for string that ends with `abc`.

- `*` = Asterisk
    - It **matches zero or more string**; It **can skip matching characters**
    - Eg: `he*` = `hey`, `hello`, `heat`...
    - It can match any number of characters that starts after `he...`.
    - In case, it can't match any, it will look for `he` only, since `*` it's not necessary to add a character anyway.

- `+` = Plus Sign
    - It **matches one or more characters**; Similar to `.` (dot), but it must match atleast one character.
    - Eg: `+uck` = `luck`, `duck`, `suck`(_atleast one_) || `gluck`(_more than one_)

- `?` = Question Sign
    - It matches **zero or one character**; Similar to `.` (dot), but it can skip matching
    - Eg: `lie?` = `lied` (atmost one) || `lie` (zero)

- `|` = Pipe Sign
    - It **matches characters separated by `|`** pipe symbol.
    - Eg: `cat|dog` = Matches either `cat` or `dob`; Similar to _OR gate or operator._

- `()` = Paranthesis
    - It match **all characters that enclosed within** it; Order of character matters.
    - Eg: `(abc|def)` = Match `abc` or `def`; This is most commonly used for **combining with other metacharacters** when searching for texts.

### 3. Special Sequences
Special sequences are used to  enhance the pattern matching by providing matching patterns logic and consist of `\` (_backslash_) and alphabetical characters

Using backslash followed by a character, we can mention the pattern matching logic.

| Symbol | Meaning                                              | Character Class / Description    |
|--------|------------------------------------------------------|----------------------------------|
| `\b`   | Matches a **word boundary** (start or end of a word) | —                                |
| `\B`   | Matches **not** at a word boundary                   | —                                |
| `\w`   | Matches any **word character**                       | `[a-zA-Z0-9_]`                   |
| `\W`   | Matches any **non-word character**                   | `[^a-zA-Z0-9_]`                  |
| `\d`   | Matches any **digit**                                | `[0-9]`                          |
| `\D`   | Matches any **non-digit**                            | `[^0-9]`                         |
| `\s`   | Matches any **whitespace character**                 | `[ \t\n\r\f\v]`                  |
| `\S`   | Matches any **non-whitespace character**             | `[^ \t\n\r\f\v]`                 |
| `\n`   | Matches a **newline** character                      | —                                |
| `\f`   | Matches a **form-feed** character                    | —                                |
| `\t`   | Matches a **tab** character                          | —                                |
| `\v`   | Matches a **vertical tab** character                 | —                                |
| `$`    | Matches at the **end** of a string                   | —                                |
| `^`    | Start of line/string                                 | Start of any line (_multi-line_) |
| `$`    | End of line/string                                   | End of any line (_multi-line_)   |
| `\A`   | Start of string                                      | Only very beginning of string    |
| `\Z`   | End of string                                        | Only very end of string          |

> **Notes:**
> - In regular expressions, `^` and `$` are used for matching the start and end of a string, not `A` and `Z`. (_as far as I know_)
> - The backslash (`\`) is required for escape sequences like `\b`, `\d`, etc.
> - `[a-zA-Z0-9_]` is the character class for word characters (`\w`).
> - `[ \t\n\r\f\v]` is the character class for whitespace (`\s`).


### 4. Character Classes
In simple terms, Character Classes **helps finding set of characters** easily. The charactes are enclosed within a square bracket`[]`.

| Character Class | Description                                         |
|-----------------|-----------------------------------------------------|
| `[abc]`         | Matches the letter `a`/`b`/`c`                      |
| `[abc][xz]`     | Match letter `a`/`b`/`c` followed by either `x`/`z` |
| `[^abc]`        | Match all letters except `a`/`b`/`c`.               |
| `[0-9]`         | Match all digits from 0-9 (_inclusive range_)       |
| `[a-z]`         | Match any lowercase letters                         |
| `[A-Z]`         | Match any uppercase letters                         |
| `[a-zA-Z]`      | Match lowercase/uppercase letters                   |
| `[a-zA-Z0-9_]`  | Match any alphanumeric character                    |
| `[m-p2-8]`      | Ranges between `m-p` letters and `2-8` numbers      |


### 5. Occurrence Indicators
Some of the metacharacters are also considered as occurence indicators. It plays the vital role in determining the occurences of characters.

This is the basic occurence indicators:
| Occurrence Indicators | Description             |
|-----------------------|-------------------------|
| `+`                   | Matches **one or more** |
| `?`                   | Matches **zero or one** |
| `*`                   | Matches **zero or more**  |

These are some advanced that uses curly braces `{}`:
| Occurrence Indicators | Description                              |
|-----------------------|------------------------------------------|
| `{n}`                 | Matches **exactly `n` number of times**  |
| `{n,}`                | Matches at **atleast n number of times** |
| `{n,m}`               | Matches from **`n` to `m` times**        |
| `{,n}`                | Matches **upto n times**                 |


**References**:
1. https://towardsdatascience.com/the-essentials-of-regular-expressions-b52af8fe271a/
2. https://mahabub-r.medium.com/mastering-regular-expressions-the-ultimate-guide-from-basics-to-advanced-techniques-ffb6a7ffd564
3. https://pynative.com/python-regex-special-sequences-and-character-classes/
