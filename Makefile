#!/usr/bin/make

####################
# cpp
####################

# コンパイラ設定
CXX		= g++
DEVCXXFLAGS	= -O3 -Wall
DBGCXXFLAGS	= -g3 -O0 -Wall
LIBS 		=
INCLUDES	= -I./header

# ディレクトリ
SRCDIR		= ./src
DEVOBJDIR 	= ./obj/dev
DBGOBJDIR 	= ./obj/debug
DEVTGTDIR	= ./bin/dev
DBGTGTDIR	= ./bin/debug

# 実行ファイル名
TGT		= out
DEVTGT		= $(addprefix $(DEVTGTDIR)/, $(TGT))
DBGTGT		= $(addprefix $(DBGTGTDIR)/, $(TGT))


# ディレクトリリストを生成
SRCDIRLIST	= $(shell find $(SRCDIR) -type d)
# cppファイルのリストを生成
SRCLIST		= $(foreach d, $(SRCDIRLIST), $(wildcard $(d)/*.cpp))
# トリミングしてディレクトリ構造を抽出
CUTSRCLIST	= $(subst $(SRCDIR),.,$(SRCLIST))
# オブジェクトファイル名を決定
DEVOBJLIST	= $(addprefix $(DEVOBJDIR)/, $(CUTSRCLIST:.cpp=.o))
DBGOBJLIST	= $(addprefix $(DBGOBJDIR)/, $(CUTSRCLIST:.cpp=.o))
# オブジェクトファイル用のディレクトリ構造をリスト化
DEVOBJDIRLIST	= $(addprefix $(DEVOBJDIR)/, $(SRCDIRLIST))
DBGOBJDIRLIST	= $(addprefix $(DBGOBJDIR)/, $(SRCDIRLIST))

# 実行ファイルを生成
$(DEVTGT): $(DEVOBJLIST)
	@if [ ! -e $(DEVTGTDIR) ]; then mkdir -p $(DEVTGTDIR); fi
	$(CXX) -o $@ $^ $(LIBS)

$(DBGTGT): $(DBGOBJLIST)
	@if [ ! -e $(DBGTGTDIR) ]; then mkdir -p $(DBGTGTDIR); fi
	$(CXX) -o $@ $^ $(LIBS)

# 中間バイナリを生成
$(DEVOBJDIR)/%.o: $(SRCDIR)/%.cpp
	@if [ ! -e `dirname $@` ]; then mkdir -p `dirname $@`; fi
	$(CXX) $(DEVCXXFLAGS) $(INCLUDES) -o $@ -c $<

$(DBGOBJDIR)/%.o: $(SRCDIR)/%.cpp
	@if [ ! -e `dirname $@` ]; then mkdir -p `dirname $@`; fi
	$(CXX) $(DBGCXXFLAGS) $(INCLUDES) -o $@ -c $<

# ビルドターゲット設定
.PHONY: build build-debug build-all clean clean-debug clean-all

build: $(DEVTGT)

build-debug: $(DBGTGT)

build-all: build build-debug

clean:
	rm -rf $(DEVOBJLIST) $(DEVTGT)

clean-debug:
	rm -rf $(DBGOBJLIST) $(DBGTGT)

clean-all: clean clean-debug

####################
# docker
####################

CONTAINER	= docker-cpp-template

.PHONY: docker-up docker-down docker-exec

docker-up:
	@docker compose up -d

docker-down:
	@docker compose down

docker-exec:
	@docker container exec -it $(CONTAINER) /bin/sh
