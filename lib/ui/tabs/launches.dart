import 'package:big_tip/big_tip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:row_collection/row_collection.dart';
import 'package:search_page/search_page.dart';

import '../../models/index.dart';
import '../../repositories/launches.dart';
import '../../util/menu.dart';
import '../pages/index.dart';
import '../widgets/index.dart';

/// This tab holds information a specific type of launches,
/// upcoming or latest, defined by the model.
class LaunchesTab extends StatelessWidget {
  final LaunchType type;

  const LaunchesTab(this.type);

  @override
  Widget build(BuildContext context) {
    return Consumer<LaunchesRepository>(
      builder: (context, model, child) => Scaffold(
        body: SliverPage<LaunchesRepository>.slide(
          title: FlutterI18n.translate(
            context,
            type == LaunchType.upcoming
                ? 'spacex.upcoming.title'
                : 'spacex.latest.title',
          ),
          slides: model.photos,
          popupMenu: Menu.home,
          body: <Widget>[
            SliverList(
              delegate: SliverChildBuilderDelegate(
                _buildLaunch,
                childCount: model.launches?.length,
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: null,
          tooltip: FlutterI18n.translate(
            context,
            'spacex.other.tooltip.search',
          ),
          onPressed: () => showSearch(
            context: context,
            delegate: SearchPage<Launch>(
              items: model.launches,
              searchLabel: FlutterI18n.translate(
                context,
                'spacex.other.tooltip.search',
              ),
              suggestion: BigTip(
                subtitle: FlutterI18n.translate(
                  context,
                  'spacex.search.suggestion.launch',
                ),
                child: Icon(Icons.search),
              ),
              failure: BigTip(
                subtitle: FlutterI18n.translate(
                  context,
                  'spacex.search.failure',
                ),
                child: Icon(Icons.sentiment_dissatisfied),
              ),
              filter: (launch) => [
                launch.rocket.name,
                launch.name,
                launch.getNumber,
                launch.year,
              ],
              builder: (launch) => Column(
                children: <Widget>[
                  ListCell(
                    title: launch.name,
                    trailing: MissionNumber(launch.getNumber),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LaunchPage(launch),
                      ),
                    ),
                  ),
                  Separator.divider(indent: 16)
                ],
              ),
            ),
          ),
          child: Icon(Icons.search),
        ),
      ),
    );
  }

  Widget _buildLaunch(BuildContext context, int index) {
    return Consumer<LaunchesRepository>(
      builder: (context, model, child) {
        final Launch launch = model.launches[index];
        return Column(children: <Widget>[
          ListCell(
            leading: HeroImage.list(
              url: launch.patchUrl,
              tag: launch.getNumber,
            ),
            title: launch.name,
            subtitle: launch.getLaunchDate(context),
            trailing: MissionNumber(launch.getNumber),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LaunchPage(launch)),
            ),
          ),
          Separator.divider(indent: 72)
        ]);
      },
    );
  }
}
