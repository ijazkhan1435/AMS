//package com.example.flutter_application_1.utility;
//
//
///*
// *
// * This file is licensed under The Code Project Open License (CPOL) 1.02
// * http://www.codeproject.com/info/cpol10.aspx
// * http://www.codeproject.com/info/CPOL.zip
// *
// * License Preamble:
// * This License governs Your use of the Work. This License is intended to allow developers to use the Source
// * Code and Executable Files provided as part of the Work in any application in any form.
// *
// * The main points subject to the terms of the License are:
// *    Source Code and Executable Files can be used in commercial applications;
// *    Source Code and Executable Files can be redistributed; and
// *    Source Code can be modified to create derivative works.
// *    No claim of suitability, guarantee, or any warranty whatsoever is provided. The software is provided "as-is".
// *    The Article(s) accompanying the Work may not be distributed or republished without the Author's consent
// *
// * This License is entered between You, the individual or other entity reading or otherwise making use of
// * the Work licensed pursuant to this License and the individual or other entity which offers the Work
// * under the terms of this License ("Author").
// *  (See Links above for full license text)
// */
//
//import android.app.AlertDialog;
//import android.content.Context;
//import android.content.DialogInterface;
//import android.os.Environment;
//import android.view.LayoutInflater;
//import android.view.View;
//import android.view.ViewGroup;
//import android.view.ViewGroup.LayoutParams;
//import android.widget.AdapterView;
//import android.widget.AdapterView.OnItemClickListener;
//import android.widget.ArrayAdapter;
//import android.widget.Button;
//import android.widget.EditText;
//import android.widget.LinearLayout;
//import android.widget.ListView;
//import android.widget.RelativeLayout;
//import android.widget.Spinner;
//import android.widget.TextView;
//
//import java.io.File;
//import java.io.IOException;
//import java.util.ArrayList;
//import java.util.Collections;
//import java.util.Comparator;
//import java.util.List;
//
//import com.example.flutter_application_1.R;
//
//
//public class SimpleFileDialog {
//    public enum Type {
//        FILE_CHOOSE,
//        FILE_CREATE,
//        FILE_CREATE2
//    }
//
//    private Type mSelectType = Type.FILE_CREATE;
//    private String m_sdcardDirectory = "";
//    private String mTitle = "";
//    private String mCreateExtension = "";
//    private ArrayList<String> mChooseExtensions = new ArrayList<>(); //could choose multi kind files.
//    private Context m_context;
//    private Button mbtnNext = null; //for Wizard
//    private TextView m_tvCurrentPath;
//    private TextView mtvChosenFileTitle;
//    private TextView mtvChosenFile;
//    private TextView mtvCreateFileTitle;
//    private EditText medCreateFile;
//    private TextView mtvCreateFileExt;
//    private Spinner mPathType;
//    private String m_dir = "";
//    private List<String> m_subdirs = null;
//    private SimpleFileDialogListener m_SimpleFileDialogListener = null;
//    private ArrayAdapter<String> m_listAdapter = null;
//    private ArrayAdapter adapterPath;
//
//    public SimpleFileDialog(Context context, String title, String extCreate, Type file_select_type, SimpleFileDialogListener SimpleFileDialogListener) {
//        mSelectType = file_select_type;
//        mTitle = title;
//        mCreateExtension = String.format(".%s", extCreate);
//        m_context = context;
//        m_sdcardDirectory = Environment.getExternalStorageDirectory().getAbsolutePath();
//        m_SimpleFileDialogListener = SimpleFileDialogListener;
//
//        try {
//            m_sdcardDirectory = new File(m_sdcardDirectory).getCanonicalPath();
//        } catch (IOException e) {
//            e.printStackTrace();
//        }
//    }
//
//    public SimpleFileDialog(Context context, String title, ArrayList<String> exts, Type file_select_type, SimpleFileDialogListener SimpleFileDialogListener) {
//        this(context, title, "", file_select_type, SimpleFileDialogListener);
//        mChooseExtensions = exts;
//
//        for (int idxChoose = 0; idxChoose < mChooseExtensions.size(); idxChoose++) {
//            String ext = mChooseExtensions.get(idxChoose);
//            String chooseExt = String.format(".%s", ext);
//            mChooseExtensions.set(idxChoose, chooseExt);
//        }
//    }
//
//    ////////////////////////////////////////////////////////////////////////////////
//    // chooseFile_or_Dir(String dir) - load directory chooser dialog for initial
//    // input 'dir' directory
//    ////////////////////////////////////////////////////////////////////////////////
//    public void chooseFile_or_Dir(String dir) {
//        //String dirTemp = dir;
//        File dirFile = new File(dir);
//        String curFile = "";
//
//        if (!dirFile.exists()) {
//            dir = m_sdcardDirectory;
//        } else if (!dirFile.isDirectory()) {
//            try {
//                curFile = dirFile.getName();
//                dir = dirFile.getCanonicalPath().replaceAll(File.separator + dirFile.getName(), "");
//            } catch (IOException e) {
//                e.printStackTrace();
//            }
//        } else {
//            try {
//                dir = new File(dir).getCanonicalPath();
//            } catch (IOException ioe) {
//                return;
//            }
//        }
//
//        m_dir = dir;
//        m_subdirs = getDirectories(dir);
//
//        AlertDialog.Builder dialogBuilder = createDirectoryChooserDialog(curFile, dir, m_subdirs,
//                new OnItemClickListener() {
//                    @Override
//                    public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
//                        String m_dir_old = m_dir;
//                        String sel = "" + parent.getItemAtPosition(position);
//
//                        if (sel.charAt(sel.length() - 1) == '/') {
//                            sel = sel.substring(0, sel.length() - 1);
//                        }
//
//                        // Navigate into the sub-directory
//                        if (sel.equals("..")) {
//                            m_dir = m_dir.substring(0, m_dir.lastIndexOf("/"));
//                        } else {
//                            m_dir += "/" + sel;
//                        }
//
//                        if ((new File(m_dir).isFile())) {
//                            // If the selection is a regular file
//                            m_SimpleFileDialogListener.onFileSel(m_dir);
//                            m_dir = m_dir_old;
//                            mtvChosenFile.setText(sel);
//                        }
//
//                        updateDirectory();
//                    }
//                });
//
//
//        dialogBuilder.setPositiveButton(R.string.STR_OK, new DialogInterface.OnClickListener() {
//            @Override
//            public void onClick(DialogInterface dialog, int which) {
//                // Current directory chosen
//                // Call registered listener supplied with the chosen directory
//                if (m_SimpleFileDialogListener != null) {
//                    if (mSelectType == Type.FILE_CREATE || mSelectType == Type.FILE_CREATE2) {
//                        String temp = medCreateFile.getText().toString();
//                        if (temp.length() == 0)
//                            m_SimpleFileDialogListener.onFilePath(null);
//                        else
//                            m_SimpleFileDialogListener.onFilePath(m_dir + "/" + temp + mCreateExtension);
//                    } else if (mSelectType == Type.FILE_CHOOSE) {
//                        String temp = mtvChosenFile.getText().toString();
//                        if (temp.length() == 0)
//                            m_SimpleFileDialogListener.onFilePath(null);
//                        else
//                            m_SimpleFileDialogListener.onFilePath(m_dir + "/" + temp);
//                    }
//                }
//            }
//        }).setNegativeButton(R.string.STR_Cancel, null);
//
//
//        final AlertDialog dirsDialog = dialogBuilder.create();
//
//        // Show directory chooser dialog
//        dirsDialog.show();
//    }
//
//    private boolean createSubDir(String newDir) {
//        File newDirFile = new File(newDir);
//
//        if (!newDirFile.exists()) {
//            return newDirFile.mkdir();
//        }
//
//        return false;
//    }
//
//    private List<String> getDirectories(String dir) {
//        List<String> dirs = new ArrayList<String>();
//
//        try {
//            File dirFile = new File(dir);
//
//            // if directory is not the base sd card directory add ".." for going up one directory
//            if (!m_dir.equals(m_sdcardDirectory)) {
//                dirs.add("..");
//            }
//
//            if (!dirFile.exists() || !dirFile.isDirectory()) {
//                return dirs;
//            }
//
//            for (File file : dirFile.listFiles()) {
//                if (file.isDirectory()) {
//                    // Add "/" to directory names to identify them in the list
//                    dirs.add(file.getName() + "/");
//                } else if (mSelectType == Type.FILE_CREATE || mSelectType == Type.FILE_CREATE2) {
//                    if (mCreateExtension.length() > 0) {
//                        if (UtilityHelp.isFileByExt(file, mCreateExtension)) {
//                            dirs.add(file.getName());
//                        }
//                    } else {
//                        dirs.add(file.getName());
//                    }
//                } else if (mSelectType == Type.FILE_CHOOSE) {
//                    for (String ext : mChooseExtensions) {
//                        if (UtilityHelp.isFileByExt(file, ext)) {
//                            dirs.add(file.getName());
//                            break;
//                        }
//                    }
//                }
//            }
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//
//        Collections.sort(dirs, new Comparator<String>() {
//            public int compare(String o1, String o2) {
//                return o1.compareTo(o2);
//            }
//        });
//
//        return dirs;
//    }
//
//
//    //////////////////////////////////////////////////////////////////////////////////////////////////////////
//    //////                                   START DIALOG DEFINITION                                    //////
//    //////////////////////////////////////////////////////////////////////////////////////////////////////////
//    private AlertDialog.Builder createDirectoryChooserDialog(String curFile, String curPath, List<String> listItems, OnItemClickListener onClickListener) {
//        AlertDialog.Builder dialogBuilder = new AlertDialog.Builder(m_context);
//
//        // Create custom view for AlertDialog curPath
//        RelativeLayout dialogLayout = (RelativeLayout) LayoutInflater.from(m_context).inflate(R.layout.simple_file_chooser, null);
//        LinearLayout layChooseFile = dialogLayout.findViewById(R.id.lay_choose_file);
//        LinearLayout layCreateFile = dialogLayout.findViewById(R.id.lay_create_file);
//        m_tvCurrentPath = dialogLayout.findViewById(R.id.dialog_cur_path);
//        m_tvCurrentPath.setText(curPath);
//        mtvChosenFileTitle = dialogLayout.findViewById(R.id.chosen_file_title);
//        mtvChosenFile = dialogLayout.findViewById(R.id.chosen_file);
//        mtvCreateFileTitle = dialogLayout.findViewById(R.id.create_file_title);
//        medCreateFile = dialogLayout.findViewById(R.id.create_file);
//        mtvCreateFileExt = dialogLayout.findViewById(R.id.create_file_ext);
//
//        mPathType = dialogLayout.findViewById(R.id.spinner_path);
//        mPathType.setAdapter(adapterPath);
//
//        if (mSelectType == Type.FILE_CHOOSE) {
//            mPathType.setVisibility(View.VISIBLE);
//            layChooseFile.setVisibility(View.VISIBLE);
//            layCreateFile.setVisibility(View.GONE);
//            mtvChosenFileTitle.setText(R.string.STR_ChooseFileTitle);
//            mtvChosenFile.setText(curFile);
//        } else if (mSelectType == Type.FILE_CREATE) {
//            mPathType.setVisibility(View.GONE);
//            layChooseFile.setVisibility(View.GONE);
//            layCreateFile.setVisibility(View.VISIBLE);
//            mtvCreateFileTitle.setText(R.string.STR_CreateFileTitle);
//            medCreateFile.setText("record");
//
//            if (!curFile.isEmpty()) {
//                String curFileName = curFile;
//                int nDotIndex = curFile.length() - mCreateExtension.length();
//
//                if (curFile.indexOf(mCreateExtension) == nDotIndex) {
//                    curFileName = curFileName.substring(0, curFileName.lastIndexOf('.'));
//                }
//
//                medCreateFile.setText(curFileName);
//            }
//
//            mtvCreateFileExt.setText(mCreateExtension);
//        } else if (mSelectType == Type.FILE_CREATE2) {
//            mPathType.setVisibility(View.GONE);
//            layChooseFile.setVisibility(View.GONE);
//            layCreateFile.setVisibility(View.VISIBLE);
//            mtvCreateFileTitle.setText(R.string.STR_CreateFileTitle);
//            medCreateFile.setText("log");
//
//            if (!curFile.isEmpty()) {
//                String curFileName = curFile;
//                int nDotIndex = curFile.length() - mCreateExtension.length();
//
//                if (curFile.indexOf(mCreateExtension) == nDotIndex) {
//                    curFileName = curFileName.substring(0, curFileName.lastIndexOf('.'));
//                }
//
//                medCreateFile.setText(curFileName);
//            }
//
//            mtvCreateFileExt.setText(mCreateExtension);
//        }
//
//        dialogBuilder.setTitle(mTitle);
//        dialogBuilder.setView(dialogLayout);
//        m_listAdapter = createListAdapter(listItems);
//        ListView list = (ListView) dialogLayout.findViewById(R.id.dialoglist);
//        list.setOnItemClickListener(onClickListener);
//        list.setAdapter(m_listAdapter);
//        dialogBuilder.setCancelable(false);
//
//        return dialogBuilder;
//    }
//
//    private void updateDirectory() {
//        m_subdirs.clear();
//        m_subdirs.addAll(getDirectories(m_dir));
//        m_tvCurrentPath.setText(m_dir);
//        m_listAdapter.notifyDataSetChanged();
//    }
//
//    private ArrayAdapter<String> createListAdapter(List<String> items) {
//        return new ArrayAdapter<String>(m_context, R.layout.simple_file_dialog_list_item, items) {
//            @Override
//            public View getView(int position, View convertView, ViewGroup parent) {
//                View v = super.getView(position, convertView, parent);
//
//                if (v instanceof TextView) {
//                    // Enable list item (directory) text wrapping
//                    TextView tv = (TextView) v;
//                    tv.getLayoutParams().height = LayoutParams.WRAP_CONTENT;
//                    tv.setEllipsize(null);
//                }
//
//                return v;
//            }
//        };
//    }
//
//    //////////////////////////////////////////////////////
//    // Callback interface for selected directory
//    //////////////////////////////////////////////////////
//    public interface SimpleFileDialogListener {
//        void onFilePath(final String path);
//
//        void onFileSel(final String path);
//
//        void onFileSelNext(final String path);//for Wizard
//    }
//}