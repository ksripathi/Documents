def file_inline_replace(file_path):
    try:
        s = open(file_path).read()
        s = s.replace('TIMESTAMP(19)', 'TIMESTAMP')
        f = open(file_path, 'w')
        f.write(s)
        f.close()
    except Exception as e:
        print str(e)

if __name__ == '__main__':
    import sys
    if len(sys.argv) == 2:
        file_inline_replace(sys.argv[1])
    else:
        print "Invalid parameters"

