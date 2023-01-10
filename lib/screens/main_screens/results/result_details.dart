// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'dart:io';

import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dar_elteb/cubit/cubit.dart';
import 'package:dar_elteb/cubit/states.dart';
import 'package:dar_elteb/models/patient_models/home_appointments_model/home_result_model.dart';
import 'package:dar_elteb/models/patient_models/lab_appointments_model/lab_result_model.dart';
import 'package:dar_elteb/screens/main_screens/results/widget_components.dart';
import 'package:dar_elteb/shared/components/general_components.dart';
import 'package:dar_elteb/shared/constants/colors.dart';
import 'package:dar_elteb/shared/constants/general_constants.dart';
import 'package:dar_elteb/shared/network/local/const_shared.dart';
import 'package:dar_elteb/translations/locale_keys.g.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class ResultDetailsScreen extends StatefulWidget {
  ResultDetailsScreen(
      {Key? key,
      this.index,
      this.labResultsDataModel,
      this.homeResultsDataModel,
      this.homeId,
      this.labId})
      : super(key: key);
  LabResultsDataModel? labResultsDataModel;
  HomeResultsDataModel? homeResultsDataModel;
  int? index;
  int? labId;
  int? homeId;
  double progress = 0;
  bool loading = false;

  @override
  State<ResultDetailsScreen> createState() => _ResultDetailsScreenState();
}

class _ResultDetailsScreenState extends State<ResultDetailsScreen> {
  // bool _isLoading = true;
  PDFDocument document = PDFDocument();

  @override
  void initState() {
    if (widget.labResultsDataModel == null ||
        widget.homeResultsDataModel == null) {
      getResultsData();
    }
  }

  getResultsData() async {
    if (widget.labId != null) {
      await AppCubit.get(context).getLabResults(resultId: widget.labId);
    }
    if (widget.homeId != null) {
      await AppCubit.get(context).getHomeResults(resultId: widget.homeId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var homeResult = widget.homeResultsDataModel;
        var labResult = widget.labResultsDataModel;
        return Scaffold(
          backgroundColor: greyExtraLightColor,
          appBar: GeneralAppBar(
            title: LocaleKeys.TxtTestResult.tr(),
            appBarColor: greyExtraLightColor,
            centerTitle: false,
          ),
          body: ConditionalBuilder(
            condition: state is! AppGetLabResultsLoadingState &&
                state is! AppGetHomeResultsLoadingState,
            builder: (context) => Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Container(
                      height: 70,
                      alignment: AlignmentDirectional.center,
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(
                          radius,
                        ),
                        border: Border.all(
                          width: 1,
                          color: greyLightColor,
                        ),
                      ),
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.homeResultsDataModel != null ||
                              widget.labResultsDataModel != null)
                            Expanded(
                              child: Row(
                                children: [
                                  Text(
                                    '# ${homeResult?.id ?? labResult?.id ?? ''}',
                                    style: titleSmallStyle,
                                    textAlign: TextAlign.start,
                                  ),
                                  const Spacer(),
                                ],
                              ),
                            ),
                          if (widget.homeResultsDataModel != null ||
                              widget.labResultsDataModel != null)
                            Expanded(
                              child: Text(
                                homeResult?.date?.date ??
                                    labResult?.date?.date ??
                                    '',
                              ),
                            ),
                          if (widget.homeId != null || widget.labId != null)
                            Expanded(
                              child: Row(
                                children: [
                                  if (widget.labId != null)
                                  Text(
                                    '# ${AppCubit.get(context).labResultsModel?.data?.first.id}',
                                    style: titleSmallStyle,
                                    textAlign: TextAlign.start,
                                  ),
                                  if (widget.homeId != null)
                                    Text(
                                      '# ${AppCubit.get(context).homeResultsModel?.data?.first.id}',
                                      style: titleSmallStyle,
                                      textAlign: TextAlign.start,
                                    ),
                                  const Spacer(),
                                ],
                              ),
                            ),
                          if (widget.labId != null)
                            Expanded(
                              child: Text(
                                '${AppCubit.get(context).homeResultsModel?.data?.first.date?.date}'
                              ),
                            ),
                          if (widget.homeId != null)
                          Expanded(
                              child: Text(
                                '${AppCubit.get(context).labResultsModel?.data?.first.date?.date}'
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  if (widget.homeResultsDataModel != null ||
                      widget.labResultsDataModel != null)
                    Expanded(
                      child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) => InkWell(
                          onTap: () async {
                            if (widget.labResultsDataModel?.results?[index]
                                    .file ==
                                '') {
                              if (widget.homeResultsDataModel?.results?[index]
                                      .file ==
                                  null) {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          content: Text(LocaleKeys
                                              .txtDownloadFailed
                                              .tr()),
                                        ));
                              } else if (widget.homeResultsDataModel
                                      ?.results?[index].file ==
                                  '') {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          content: Text(LocaleKeys
                                              .txtDownloadFailed
                                              .tr()),
                                        ));
                              } else {
                                document = await PDFDocument.fromURL(
                                    '${widget.homeResultsDataModel?.results?[index].file}');
                                openFile(
                                    url:
                                        '${widget.homeResultsDataModel?.results?[index].file}',
                                    name: 'file.pdf');
                                PDFViewer(
                                  document: document,
                                );
                              }
                            } else if (widget.labResultsDataModel
                                    ?.results?[index].file ==
                                null) {
                              if (widget.homeResultsDataModel?.results?[index]
                                      .file ==
                                  null) {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          content: Text(LocaleKeys
                                              .txtDownloadFailed
                                              .tr()),
                                        ));
                              } else if (widget.homeResultsDataModel
                                      ?.results?[index].file ==
                                  '') {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          content: Text(LocaleKeys
                                              .txtDownloadFailed
                                              .tr()),
                                        ));
                              } else {
                                document = await PDFDocument.fromURL(
                                    '${widget.homeResultsDataModel?.results?[index].file}');
                                openFile(
                                    url:
                                        '${widget.homeResultsDataModel?.results?[index].file}',
                                    name: 'file.pdf');
                                PDFViewer(
                                  document: document,
                                );
                              }
                            } else {
                              document = await PDFDocument.fromURL(
                                  '${widget.labResultsDataModel?.results?[index].file}');
                              openFile(
                                  url:
                                      '${widget.labResultsDataModel?.results?[index].file}',
                                  name: 'file.pdf');
                              PDFViewer(
                                document: document,
                              );
                            }
                          },
                          child: widget.loading
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: LinearProgressIndicator(
                                    minHeight: 10,
                                    value: widget.progress,
                                  ),
                                )
                              : ResultsDetailsCart(
                                  homeResultsDataFileModel: widget
                                      .homeResultsDataModel?.results?[index],
                                  labResultsDataFileModel: widget
                                      .labResultsDataModel?.results?[index],
                                ),
                        ),
                        separatorBuilder: (context, index) => verticalMiniSpace,
                        itemCount: homeResult?.results?.length ??
                            labResult?.results?.length ??
                            0,
                      ),
                    ),
                  if (widget.homeId != null)
                    Expanded(
                      child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) => InkWell(
                          onTap: () async {
                            if (AppCubit.get(context)
                                    .labResultsModel
                                    ?.data
                                    ?.first
                                    .results?[index]
                                    .file ==
                                '') {
                              if (AppCubit.get(context)
                                      .homeResultsModel
                                      ?.data
                                      ?.first
                                      .results?[index]
                                      .file ==
                                  null) {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          content: Text(LocaleKeys
                                              .txtDownloadFailed
                                              .tr()),
                                        ));
                              } else if (AppCubit.get(context)
                                      .homeResultsModel
                                      ?.data
                                      ?.first
                                      .results?[index]
                                      .file ==
                                  '') {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          content: Text(LocaleKeys
                                              .txtDownloadFailed
                                              .tr()),
                                        ));
                              } else {
                                document = await PDFDocument.fromURL(
                                    '${AppCubit.get(context).homeResultsModel?.data?.first.results?[index].file}');
                                openFile(
                                    url:
                                        '${AppCubit.get(context).homeResultsModel?.data?.first.results?[index].file}',
                                    name: 'file.pdf');
                                PDFViewer(
                                  document: document,
                                );
                              }
                            } else if (AppCubit.get(context)
                                    .labResultsModel
                                    ?.data
                                    ?.first
                                    .results?[index]
                                    .file ==
                                null) {
                              if (AppCubit.get(context)
                                      .homeResultsModel
                                      ?.data
                                      ?.first
                                      .results?[index]
                                      .file ==
                                  null) {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          content: Text(LocaleKeys
                                              .txtDownloadFailed
                                              .tr()),
                                        ));
                              } else if (AppCubit.get(context)
                                      .homeResultsModel
                                      ?.data
                                      ?.first
                                      .results?[index]
                                      .file ==
                                  '') {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          content: Text(LocaleKeys
                                              .txtDownloadFailed
                                              .tr()),
                                        ));
                              } else {
                                document = await PDFDocument.fromURL(
                                    '${AppCubit.get(context).homeResultsModel?.data?.first.results?[index].file}');
                                openFile(
                                    url:
                                        '${AppCubit.get(context).homeResultsModel?.data?.first.results?[index].file}',
                                    name: 'file.pdf');
                                PDFViewer(
                                  document: document,
                                );
                              }
                            } else {
                              document = await PDFDocument.fromURL(
                                  '${AppCubit.get(context).labResultsModel?.data?.first.results?[index].file}');
                              openFile(
                                  url:
                                      '${AppCubit.get(context).labResultsModel?.data?.first.results?[index].file}',
                                  name: 'file.pdf');
                              PDFViewer(
                                document: document,
                              );
                            }
                          },
                          child: widget.loading
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: LinearProgressIndicator(
                                    minHeight: 10,
                                    value: widget.progress,
                                  ),
                                )
                              : ResultsDetailsCart(
                                  homeResultsDataFileModel: AppCubit.get(context).homeResultsModel?.data?.first.results?[index],
                                ),
                        ),
                        separatorBuilder: (context, index) => verticalMiniSpace,
                        itemCount: AppCubit.get(context).homeResultsModel?.data?.first.results?.length ?? 0,
                      ),
                    ),
                  if (widget.labId != null)
                    Expanded(
                      child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) => InkWell(
                          onTap: () async {
                            if (AppCubit.get(context)
                                .labResultsModel
                                ?.data
                                ?.first
                                .results?[index]
                                .file ==
                                '') {
                              if (AppCubit.get(context)
                                  .homeResultsModel
                                  ?.data
                                  ?.first
                                  .results?[index]
                                  .file ==
                                  null) {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      content: Text(LocaleKeys
                                          .txtDownloadFailed
                                          .tr()),
                                    ));
                              } else if (AppCubit.get(context)
                                  .homeResultsModel
                                  ?.data
                                  ?.first
                                  .results?[index]
                                  .file ==
                                  '') {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      content: Text(LocaleKeys
                                          .txtDownloadFailed
                                          .tr()),
                                    ));
                              } else {
                                document = await PDFDocument.fromURL(
                                    '${AppCubit.get(context).homeResultsModel?.data?.first.results?[index].file}');
                                openFile(
                                    url:
                                    '${AppCubit.get(context).homeResultsModel?.data?.first.results?[index].file}',
                                    name: 'file.pdf');
                                PDFViewer(
                                  document: document,
                                );
                              }
                            } else if (AppCubit.get(context)
                                .labResultsModel
                                ?.data
                                ?.first
                                .results?[index]
                                .file ==
                                null) {
                              if (AppCubit.get(context)
                                  .homeResultsModel
                                  ?.data
                                  ?.first
                                  .results?[index]
                                  .file ==
                                  null) {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      content: Text(LocaleKeys
                                          .txtDownloadFailed
                                          .tr()),
                                    ));
                              } else if (AppCubit.get(context)
                                  .homeResultsModel
                                  ?.data
                                  ?.first
                                  .results?[index]
                                  .file ==
                                  '') {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      content: Text(LocaleKeys
                                          .txtDownloadFailed
                                          .tr()),
                                    ));
                              } else {
                                document = await PDFDocument.fromURL(
                                    '${AppCubit.get(context).homeResultsModel?.data?.first.results?[index].file}');
                                openFile(
                                    url:
                                    '${AppCubit.get(context).homeResultsModel?.data?.first.results?[index].file}',
                                    name: 'file.pdf');
                                PDFViewer(
                                  document: document,
                                );
                              }
                            } else {
                              document = await PDFDocument.fromURL(
                                  '${AppCubit.get(context).labResultsModel?.data?.first.results?[index].file}');
                              openFile(
                                  url:
                                  '${AppCubit.get(context).labResultsModel?.data?.first.results?[index].file}',
                                  name: 'file.pdf');
                              PDFViewer(
                                document: document,
                              );
                            }
                          },
                          child: widget.loading
                              ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: LinearProgressIndicator(
                              minHeight: 10,
                              value: widget.progress,
                            ),
                          )
                              : ResultsDetailsCart(
                            labResultsDataFileModel: AppCubit.get(context).labResultsModel?.data?.first.results?[index],
                          ),
                        ),
                        separatorBuilder: (context, index) => verticalMiniSpace,
                        itemCount: AppCubit.get(context).labResultsModel?.data?.first.results?.length ?? 0,
                      ),
                    ),
                ],
              ),
            ),
            fallback: (context) =>
                const Center(child: CircularProgressIndicator.adaptive()),
          ),
        );
      },
    );
  }

  Future openFile({required String url, String? name}) async {
    final file = await downloadFile(url, name!);
    if (file == null) return;
    OpenFile.open(file.path);
  }

  Future<File?> downloadFile(String url, String name) async {
    final appStorage = await getApplicationDocumentsDirectory();
    final file = File('${appStorage.path}/$name');
    try {
      setState(() {
        widget.loading = true;
        widget.progress = 0;
      });
      final response = await Dio().get(url,
          options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            receiveTimeout: 0,
          ), onReceiveProgress: (value1, value2) {
        setState(() {
          widget.progress = value1 / value2;
        });
      });

      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(LocaleKeys.txtDownloadedSuccess.tr()),
        ),
      );
      setState(() {
        widget.loading = false;
      });
      return file;
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      return null;
    }
  }
}
