# Conventions for Moyoon's Development Team
This file contains all the conventions that the team should follow during development. This file should cover all aspects, **in case you didn't find a convention for what you are looking for, create a new one and ('git commit' + 'git push') to the repository so all the team members see it and follow it**.

## General
### Folders naming:
all folders names should be lower cased and without any spaces, replace spaces with dashes "-", example:	'questions-screens'

## Colors & Fonts
//TODO

## Commit Messages (Git & Github)
<article>
<h4>Message Structure</h4>
<p>A commit messages consists of three distinct parts separated by a blank line: the title, an optional body and an optional footer. The layout looks like this:</p>

<pre><code>type: subject

body

footer</code></pre>

<p>The title consists of the type of the message and subject.</p>
</article>

<article>
<h4>The Type</h4>
<p>The type is contained within the title and can be one of these types:</p>

<ul>
<li><strong>feat:</strong> a new feature</li>
<li><strong>fix:</strong> a bug fix</li>
<li><strong>docs:</strong> changes to documentation</li>
<li><strong>style:</strong> formatting, missing semi colons, etc; no code change</li>
<li><strong>refactor:</strong> refactoring code</li>
<li><strong>test:</strong> adding tests, refactoring test; no production code change</li>
</ul>
</article>

<article>
<h4>The Subject</h4>
<p>Subjects should be no greater than 50 characters, should begin with a capital letter and do not end with a period.</p>

<p>Use an imperative tone to describe what a commit does, rather than what it did. For example, use <strong>change</strong>; not changed or changes.</p>
</article>

<article>
<h4>The Body</h4>
<p>Not all commits are complex enough to warrant a body, therefore it is optional and only used when a commit requires a bit of explanation and context. Use the body to explain the <strong>what</strong> and <strong>why</strong> of a commit, not the how.</p>

<p>When writing a body, the blank line between the title and the body is required and you should limit the length of each line to no more than 72 characters.</p>
</article>

<article>
<h4>The Footer</h4>
<p>The footer is optional and is used to reference issue tracker IDs.</p>
</article>

<article>
<h4>Example Commit Message</h4>
<pre><code>feat: Summarize changes in around 50 characters or less

More detailed explanatory text, if necessary. Wrap it to about 72
characters or so. In some contexts, the first line is treated as the
subject of the commit and the rest of the text as the body. The
blank line separating the summary from the body is critical (unless
you omit the body entirely); various tools like `log`, `shortlog`
and `rebase` can get confused if you run the two together.

Explain the problem that this commit is solving. Focus on why you
are making this change as opposed to how (the code explains that).
Are there side effects or other unintuitive consequenses of this
change? Here's the place to explain them.

Further paragraphs come after blank lines.

 - Bullet points are okay, too

 - Typically a hyphen or asterisk is used for the bullet, preceded
   by a single space, with blank lines in between, but conventions
   vary here

If you use an issue tracker, put references to them at the bottom,
like this:

Resolves: #123
See also: #456, #789</code></pre>
</article>


