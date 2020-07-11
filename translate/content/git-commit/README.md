# Git commit 多行信息提交

git commit可接受多个消息标志(-m)来允许多行提交

> 原文地址：https://www.stefanjudis.com/today-i-learned/git-commit-accepts-several-message-flags-m-to-allow-multiline-commits/
>
> 原文作者：Stephan Schneider

在命令行上使用git时，您可能已经使用了消息标志（-m）。 它允许开发人员在调用git commit时内联定义提交消息。

```bash
git commit -m "my commit message"
```

我不是这种方法的最大支持者，因为我更喜欢在vim中编辑提交消息（我仅用于编写提交消息）。 它使我有机会仔细检查我提交的文件。

今天，我了解到 `git commit `命令接受多个消息标志。 😲

事实证明，您可以多次使用 `-m` 选项。 git文档包括以下段落：

> 如果给出了多个-m选项，则它们的值被串联为单独的段落

如果运行以下命令

```bash
git co -m "commit title" -m "commit description"
```

这可以实现多行提交。

```bash
Author: stefan judis 
Date:   Tue Jul 7 21:53:21 2020 +0200

    commit title

    commit description

 test.txt | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
```

您可以使用多个 `-m` 标志来创建“多行提交”，而我不得不承认，在某些情况下这可能非常方便。

编辑：一些人指出，通过打开引号，按Enter并再次关闭带引号的提交，可以实现相同的提交结构，包括标题和正文（多行）。

```bash
git commit -m "commit title
>
> commit description"
[master 2fe1ef8] commit title
 1 file changed, 0 insertions(+), 0 deletions(-)
 create mode 100644 test-2.txt
```

