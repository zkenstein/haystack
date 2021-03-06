import 'package:redux/redux.dart';
import 'package:${ProjectName}/redux/action_report.dart';
import 'package:${ProjectName}/redux/app/app_state.dart';
import 'package:${ProjectName}/redux/${(ModelEntryName)?lower_case}/${(ModelEntryName)?lower_case}_actions.dart';
import 'package:${ProjectName}/data/model/${(ModelEntryName)?lower_case}_data.dart';
import 'package:${ProjectName}/data/remote/${(ModelEntryName)?lower_case}_repository.dart';
<#if genDatabase>
import 'package:${ProjectName}/data/db/${(ModelEntryName)?lower_case}_repository_db.dart';
</#if>
import 'package:${ProjectName}/redux/${(ModelEntryName)?lower_case}/${(ModelEntryName)?lower_case}_actions.dart';
import 'package:${ProjectName}/data/model/page_data.dart';

List<Middleware<AppState>> create${ModelEntryName}Middleware([
  ${ModelEntryName}Repository _repository = const ${ModelEntryName}Repository(),
  <#if genDatabase>
  ${ModelEntryName}RepositoryDB _repositoryDB = const ${ModelEntryName}RepositoryDB(),
  </#if>
]) {
  <#if ModelEntryName=="User">
  final login = _createLogin(_repository<#if genDatabase>, _repositoryDB</#if>);
  </#if>
  final get${ModelEntryName} = _createGet${ModelEntryName}(_repository<#if genDatabase>, _repositoryDB</#if>);
  final get${ModelEntryName}s = _createGet${ModelEntryName}s(_repository<#if genDatabase>, _repositoryDB</#if>);
  final create${ModelEntryName} = _createCreate${ModelEntryName}(_repository<#if genDatabase>, _repositoryDB</#if>);
  final update${ModelEntryName} = _createUpdate${ModelEntryName}(_repository<#if genDatabase>, _repositoryDB</#if>);
  final delete${ModelEntryName} = _createDelete${ModelEntryName}(_repository<#if genDatabase>, _repositoryDB</#if>);
  final search${ModelEntryName} = _createSearch${ModelEntryName}(_repository);

  return [
    <#if ModelEntryName=="User">
    TypedMiddleware<AppState, ${ModelEntryName}LoginAction>(login),
    </#if>
    TypedMiddleware<AppState, Get${ModelEntryName}Action>(get${ModelEntryName}),
    TypedMiddleware<AppState, Get${ModelEntryName}sAction>(get${ModelEntryName}s),
    TypedMiddleware<AppState, Create${ModelEntryName}Action>(create${ModelEntryName}),
    TypedMiddleware<AppState, Update${ModelEntryName}Action>(update${ModelEntryName}),
    TypedMiddleware<AppState, Delete${ModelEntryName}Action>(delete${ModelEntryName}),
    TypedMiddleware<AppState, Search${ModelEntryName}Action>(search${ModelEntryName}),
  ];
}

<#if ModelEntryName=="User">
Middleware<AppState> _createLogin(
    ${ModelEntryName}Repository repository<#if genDatabase>, ${ModelEntryName}RepositoryDB repositoryDB</#if>) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    repository.login(action.l).then((item) {
      next(Sync${ModelEntryName}Action(${(ModelEntryName)?lower_case}: item));
      completed(action);
    }).catchError((error) {
      catchError(action, error);
    });
  };
}
</#if>

Middleware<AppState> _createGet${ModelEntryName}(
    ${ModelEntryName}Repository repository<#if genDatabase>, ${ModelEntryName}RepositoryDB repositoryDB</#if>) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    if (action.${clsUNName} == null) {
      idEmpty(action);
    } else {
      repository.get${ModelEntryName}(action.${clsUNName}).then((item) {
        next(Sync${ModelEntryName}Action(${(ModelEntryName)?lower_case}: item));
        completed(action);
      }).catchError((error) {
        catchError(action, error);
      });
    }
  };
}

Middleware<AppState> _createGet${ModelEntryName}s(
    ${ModelEntryName}Repository repository<#if genDatabase>, ${ModelEntryName}RepositoryDB repositoryDB</#if>) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    if (action.isRefresh) {
      store.state.${(ModelEntryName)?lower_case}State.page.currPage = 1;
      store.state.${(ModelEntryName)?lower_case}State.${(ModelEntryName)?lower_case}s.clear();
    } else {
      var p = ++store.state.${(ModelEntryName)?lower_case}State.page.currPage;
      if (p > ++store.state.${(ModelEntryName)?lower_case}State.page.totalPage) {
        noMoreItem(action);
        return;
      }
    }
    repository
        .get${ModelEntryName}sList(
            "sorting",
            store.state.${(ModelEntryName)?lower_case}State.page.currPage,
            store.state.${(ModelEntryName)?lower_case}State.page.pageSize)
        .then((map) {
      if (map.isNotEmpty) {
        var page = Page(
            currPage: map["currPage"],
            totalPage: map["totalPage"],
            totalCount: map["totalCount"]);
        var l = map["list"] ?? List();
        List<${ModelEntryName}> list =
            l.map<${ModelEntryName}>((item) => new ${ModelEntryName}.fromJson(item)).toList();
        next(Sync${ModelEntryName}sAction(page: page, ${(ModelEntryName)?lower_case}s: list));
      }
      completed(action);
    }).catchError((error) {
      catchError(action, error);
    });
//    repositoryDB
//        .get${ModelEntryName}sList(
//            "id",
//            store.state.${(ModelEntryName)?lower_case}State.page.pageSize,
//            store.state.${(ModelEntryName)?lower_case}State.page.pageSize *
//                store.state.${(ModelEntryName)?lower_case}State.page.currPage)
//        .then((map) {
//      if (map.isNotEmpty) {
//        var page = Page(currPage: store.state.${(ModelEntryName)?lower_case}State.page.currPage + 1);
//        next(Sync${ModelEntryName}sAction(page: page, ${(ModelEntryName)?lower_case}s: map));
//        completed(action);
//      }
//    }).catchError((error) {
//      catchError(action, error);
//    });
  };
}

Middleware<AppState> _createCreate${ModelEntryName}(
    ${ModelEntryName}Repository repository<#if genDatabase>, ${ModelEntryName}RepositoryDB repositoryDB</#if>) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    repository.create${ModelEntryName}(action.${(ModelEntryName)?lower_case}).then((item) {
      next(Sync${ModelEntryName}Action(${(ModelEntryName)?lower_case}: item));
      completed(action);
    }).catchError((error) {
      catchError(action, error);
    });
  };
}

Middleware<AppState> _createUpdate${ModelEntryName}(
    ${ModelEntryName}Repository repository<#if genDatabase>, ${ModelEntryName}RepositoryDB repositoryDB</#if>) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    repository.update${ModelEntryName}(action.${(ModelEntryName)?lower_case}).then((item) {
      next(Sync${ModelEntryName}Action(${(ModelEntryName)?lower_case}: item));
      completed(action);
    }).catchError((error) {
      catchError(action, error);
    });
  };
}

Middleware<AppState> _createDelete${ModelEntryName}(
    ${ModelEntryName}Repository repository<#if genDatabase>, ${ModelEntryName}RepositoryDB repositoryDB</#if>) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    repository.delete${ModelEntryName}(action.${(ModelEntryName)?lower_case}.${clsUNName}).then((item) {
      next(Remove${ModelEntryName}Action(${clsUNName}: action.${(ModelEntryName)?lower_case}.${clsUNName}));
      completed(action);
    }).catchError((error) {
      catchError(action, error);
    });
  };
}

Middleware<AppState> _createSearch${ModelEntryName}(${ModelEntryName}Repository repository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    next(SyncSearch${ModelEntryName}Action(search${ModelEntryName}s: []));
    repository.search${ModelEntryName}(action.query, 1, 30).then((search${ModelEntryName}s) {
      next(SyncSearch${ModelEntryName}Action(search${ModelEntryName}s: search${ModelEntryName}s));
      completed(action);
    }).catchError((error) {
      catchError(action, error);
    });
  };
}